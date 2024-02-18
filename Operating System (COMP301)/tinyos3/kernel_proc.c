
#include <assert.h>
#include "kernel_cc.h"
#include "kernel_proc.h"
#include "kernel_streams.h"
#include "kernel_sched.h"  //added it to include PTCB structure
#include "kernel_threads.h"


/*
 The process table and related system calls:
 - Exec
 - Exit
 - WaitPid
 - GetPid
 - GetPPid

 */
static file_ops procinfo_ops = {
  .Open = NULL,
  .Read = procinfo_read,
  .Write = procinfo_write,
  .Close = procinfo_close
};

/* The process table */
PCB PT[MAX_PROC];
unsigned int process_count;

PCB* get_pcb(Pid_t pid)
{
  return PT[pid].pstate==FREE ? NULL : &PT[pid];
}

Pid_t get_pid(PCB* pcb)
{
  return pcb==NULL ? NOPROC : pcb-PT;
}

/* Initialize a PCB */
static inline void initialize_PCB(PCB* pcb)
{
  pcb->pstate = FREE;
  pcb->argl = 0;
  pcb->args = NULL;

  for(int i=0;i<MAX_FILEID;i++)
    pcb->FIDT[i] = NULL;

  rlnode_init(& pcb->children_list, NULL);
  rlnode_init(& pcb->exited_list, NULL);
  rlnode_init(& pcb->children_node, pcb);
  rlnode_init(& pcb->exited_node, pcb);
  pcb->child_exit = COND_INIT;
}


static PCB* pcb_freelist;

void initialize_processes()
{
  /* initialize the PCBs */
  for(Pid_t p=0; p<MAX_PROC; p++) {
    initialize_PCB(&PT[p]);
  }

  /* use the parent field to build a free list */
  PCB* pcbiter;
  pcb_freelist = NULL;
  for(pcbiter = PT+MAX_PROC; pcbiter!=PT; ) {
    --pcbiter;
    pcbiter->parent = pcb_freelist;
    pcb_freelist = pcbiter;
  }

  process_count = 0;

  /* Execute a null "idle" process */
  if(Exec(NULL,0,NULL)!=0)
    FATAL("The scheduler process does not have pid==0");
}


/*
  Must be called with kernel_mutex held
*/
PCB* acquire_PCB()
{
  PCB* pcb = NULL;

  if(pcb_freelist != NULL) {
    pcb = pcb_freelist;
    pcb->pstate = ALIVE;
    pcb_freelist = pcb_freelist->parent;
    process_count++;
  }

  return pcb;
}

/*
  Must be called with kernel_mutex held
*/
void release_PCB(PCB* pcb)
{
  pcb->pstate = FREE;
  pcb->parent = pcb_freelist;
  pcb_freelist = pcb;
  process_count--;
}


/*
 *
 * Process creation
 *
 */

/*
	This function is provided as an argument to spawn,
	to execute the main thread of a process.
*/
void start_main_thread()
{
  int exitval;

  Task call =  CURPROC->main_task;
  int argl = CURPROC->argl;
  void* args = CURPROC->args;

  exitval = call(argl,args);
  Exit(exitval);
}


/*
	System call to create a new process.
 */
Pid_t sys_Exec(Task call, int argl, void* args)
{
  PCB *curproc, *newproc;

  /* The new process PCB */
  newproc = acquire_PCB();

  if(newproc == NULL) goto finish;  /* We have run out of PIDs! */

  newproc->thread_count=0; // Initialize thread_count if process created
  rlnode_init(&newproc->ptcb_list,NULL);  // NULL cause its the head!

  if(get_pid(newproc)<=1) {
    /* Processes with pid<=1 (the scheduler and the init process)
       are parentless and are treated specially. */
    newproc->parent = NULL;
  }
  else
  {
    /* Inherit parent */
    curproc = CURPROC;

    /* Add new process to the parent's child list */
    newproc->parent = curproc;
    rlist_push_front(& curproc->children_list, & newproc->children_node);

    /* Inherit file streams from parent */
    for(int i=0; i<MAX_FILEID; i++) {
       newproc->FIDT[i] = curproc->FIDT[i];
       if(newproc->FIDT[i])
          FCB_incref(newproc->FIDT[i]);
    }
  }


  /* Set the main thread's function */
  newproc->main_task = call;

  /* Copy the arguments to new storage, owned by the new process */
  newproc->argl = argl;
  if(args!=NULL) {
    newproc->args = malloc(argl);
    memcpy(newproc->args, args, argl);
  }
  else
    newproc->args=NULL;
//TODO: Init PTCB_list & thread_count

  /*
    Create and wake up the thread for the main function. This must be the last thing
    we do, because once we wakeup the new thread it may run! so we need to have finished
    the initialization of the PCB.
   */
  if(call != NULL) {
    newproc->main_thread = spawn_thread(newproc, start_main_thread);

    newproc->thread_count++;

    /*
    If call==NULL then no need of TCB creation and no nead of PTCB
    ->If above is wrong how we pass TCB to PTCB?
    */
    PTCB* ptcb_new;  //the address of the new PTCB
    ptcb_new=new_ptcb(call,argl,args);

    //TODO: check if line below is needed
    // rlnode_init(&ptcb_new->ptcb_list_node, ptcb_new);  //or can point to parent PCB
    ptcb_new->tcb=newproc->main_thread;  // link PTCB--->TCB

    newproc->main_thread->ptcb = ptcb_new;  // link PTCB<-----TCB

    rlist_push_back(&newproc->ptcb_list, &ptcb_new->ptcb_list_node);  // CAREFULL: link PCB--->PTCB

    wakeup(newproc->main_thread);
  }


finish:
  return get_pid(newproc);
}


/* System call */
Pid_t sys_GetPid()
{
  return get_pid(CURPROC);
}


Pid_t sys_GetPPid()
{
  return get_pid(CURPROC->parent);
}


static void cleanup_zombie(PCB* pcb, int* status)
{
  if(status != NULL)
    *status = pcb->exitval;

  rlist_remove(& pcb->children_node);
  rlist_remove(& pcb->exited_node);

  release_PCB(pcb);
}


static Pid_t wait_for_specific_child(Pid_t cpid, int* status)
{

  /* Legality checks */
  if((cpid<0) || (cpid>=MAX_PROC)) {
    cpid = NOPROC;
    goto finish;
  }

  PCB* parent = CURPROC;
  PCB* child = get_pcb(cpid);
  if( child == NULL || child->parent != parent)
  {
    cpid = NOPROC;
    goto finish;
  }

  /* Ok, child is a legal child of mine. Wait for it to exit. */
  while(child->pstate == ALIVE)
    kernel_wait(& parent->child_exit, SCHED_USER);

  cleanup_zombie(child, status);

finish:
  return cpid;
}


static Pid_t wait_for_any_child(int* status)
{
  Pid_t cpid;

  PCB* parent = CURPROC;

  /* Make sure I have children! */
  int no_children, has_exited;
  while(1) {
    no_children = is_rlist_empty(& parent->children_list);
    if( no_children ) break;

    has_exited = ! is_rlist_empty(& parent->exited_list);
    if( has_exited ) break;

    kernel_wait(& parent->child_exit, SCHED_USER);
  }

  if(no_children)
    return NOPROC;

  PCB* child = parent->exited_list.next->pcb;
  assert(child->pstate == ZOMBIE);
  cpid = get_pid(child);
  cleanup_zombie(child, status);

  return cpid;
}


Pid_t sys_WaitChild(Pid_t cpid, int* status)
{
  /* Wait for specific child. */
  if(cpid != NOPROC) {
    return wait_for_specific_child(cpid, status);
  }
  /* Wait for any child */
  else {
    return wait_for_any_child(status);
  }

}


void sys_Exit(int exitval)
{

  PCB *curproc = CURPROC;  /* cache for efficiency */

  /* First, store the exit status */
  curproc->exitval = exitval;

  /*
    Here, we must check that we are not the init task.
    If we are, we must wait until all child processes exit.
   */
  if(get_pid(curproc)==1) {
    while(sys_WaitChild(NOPROC,NULL)!=NOPROC);
  }

  sys_ThreadExit(exitval);
}

/* Consturcts the main procinfo_cb that will be used by SysInfo command
   Connects the FCB assigned from FCB_reserve to our procinfo streamobj(struct) 
   and streamfunc(struct of pointers to functions.)
   Returns the fid to access all the above(functions and data)
*/
Fid_t sys_OpenInfo()
{
  Fid_t fid;
  FCB*  fcb;

  if(!FCB_reserve(1,&fid,&fcb)){
    return NOFILE;  // not -1 because nofile is handled without throwing an exception in SysInfo()
  }

  procinfo_CB* proc_info = init_procinfo_cb();

  fcb->streamobj = proc_info;  // Link FCB--->procinfo struct

  fcb->streamfunc = &procinfo_ops;  // Link FCB--->procinfo_ops

  return fid;  
}

/* Create an "empty"  procinfo_CB object */
procinfo_CB* init_procinfo_cb(){
  /*Allocate the space needed from the object*/
  procinfo_CB* info= (procinfo_CB*)xmalloc(sizeof(procinfo_CB));
  /*set the cursor to 0*/
  info->PT_cursor = 0;

  info->process_info.pid = 0;

  info->process_info.ppid = 0;

  info->process_info.alive = 0;

  info->process_info.thread_count = 0;

  info->process_info.argl = 0;

  return info;
}

/* The function that will be used to return the info for *a single* PCB.
   it is called repetitively in the SysInfo() function of vsam.
   Gets as arguments a pointer to a procinfo_CB(to store the PT cursor)
   a pointer to a buffer to pass the info by reference, and the size of 
   the information as "size"(passed as sizeof(procinfo) by vsam.)
*/
int procinfo_read(void* info, char* buf, unsigned int size){
  procinfo_CB* prinfoCB = (procinfo_CB*) info;

  /* Check if we are at a valid place in the PT(process table) */
  if(prinfoCB->PT_cursor > MAX_PROC-1 || prinfoCB == NULL || buf == NULL) //size?
    return -1;

  /* Get the PCB from the current place in the PT*/
  PCB* current_pcb = &PT[prinfoCB->PT_cursor];      

  /* Bypass all the non-active PT cells*/
  while(current_pcb->pstate == FREE) {
    prinfoCB->PT_cursor++;
    if (prinfoCB->PT_cursor >= MAX_PROC )
      return -1;
    current_pcb = &PT[prinfoCB->PT_cursor];
  }

  /*  Get all the info from the current PCB and pass it inside the prinfoCB object
      to later be transferred as a "packet" by reference to the caller of the 
      procinfo_read.
  */
  prinfoCB->process_info.pid = get_pid(current_pcb);
  prinfoCB->process_info.ppid = get_pid(current_pcb->parent);

  if(current_pcb->pstate == ZOMBIE)
    prinfoCB->process_info.alive = 0;
  else
    prinfoCB->process_info.alive = 1;

  prinfoCB->process_info.thread_count = current_pcb->thread_count;
  prinfoCB->process_info.main_task = current_pcb->main_task;

  /* To safely pass the characters of args of the PCB to the args of the procinfo_CB*/
  prinfoCB->process_info.argl = current_pcb->argl;
  if(current_pcb->args!=NULL) {
    memcpy(&prinfoCB->process_info.args, current_pcb->args, prinfoCB->process_info.argl);
  }

  /*  The magic happens here: The prinfoCB that we created above, is cast in the 
      form of a character array by memcpy(), passed by reference as that, and then
      "decapsulated" from the caller function back to a procinfo object, that 
      can be referenced with its original fields(e.g. procinfo->thread_count)
  */
  memcpy(buf,&prinfoCB->process_info,sizeof(prinfoCB->process_info));
    
  /*  Increment the counter to move to the next PT cell when we are called again*/  
  prinfoCB->PT_cursor++;

  /*  Return how many characters we sent back to the caller*/
  return sizeof(prinfoCB->process_info);

}

/*   We cannot use write() with procinfo, so it is returning -1 as an error by default */
int procinfo_write(void* procinfo, const char *buf, unsigned int size){
  return -1;
}

/*  Releases the memory that the proc_info structre takes.*/
int procinfo_close(void* info){         
  /*  Cast the proc_info back to a procinfo pointer */
  procinfo_CB* proc_info = (procinfo_CB*) info;  

  if (proc_info == NULL)  // if already NULL we may not be able to free it
    return -1;  //signal failure

  free(proc_info);

  return 0;
}

