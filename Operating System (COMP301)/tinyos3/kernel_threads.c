/**
  @file kernel_sced.c
  @brief PTCB<->TCB creation and management.

  @defgroup threads Threads
  @ingroup kernel
  @brief PTCB<->TCB creation and management.

  This file defines basic helpers for PTCB access.

  @{
*/

#include "tinyos.h"
#include "kernel_sched.h"
#include "kernel_proc.h"
#include "kernel_threads.h"
#include "kernel_cc.h"
#include "kernel_streams.h"

/**
@brief A function used as an argument in spawn_thread().

Its job is to take the arguments and the location of the code that the 
thread has to run(call) from the PTCB, execute the code and then return 
its exit value
*/
void start_new_thread()
{
  int exitval;
  TCB* current_tcb=cur_thread();
  PTCB* current_ptcb = current_tcb->ptcb;  

  Task call = current_ptcb->task;
  int argl =current_ptcb->argl;
  void* args = current_ptcb->args;

  exitval = call(argl,args);
  ThreadExit(exitval);
}

/**
  @brief Create a new PTCB-TCB in the current process.

  @param task: Task to do 
  @param argl: Sum of arguments
  @param args: Arguments
  @returns The Tid of the new PTCB
  */
Tid_t sys_CreateThread(Task task, int argl, void* args)
{
  // Current process
  PCB* curproc=CURPROC; // Save current process 

  if(task==NULL)  // If there is no task no need of thread creation. In this case retern NOTHREAD.
    return NOTHREAD; 


  PTCB* ptcb_new=new_ptcb(task,argl,args); // Create and initialize the new PTCB.
  rlist_push_back(&curproc->ptcb_list, &ptcb_new->ptcb_list_node); // Instert new PTCB node at the list of Current PCB.

  ptcb_new->tcb = spawn_thread(curproc, start_new_thread); // Create the new thread.
  ptcb_new->tcb->ptcb = ptcb_new; // Link PTCB  with the new TCB
  curproc->thread_count++; // Increase thread ounter
  wakeup(ptcb_new->tcb); // Set to TCB's state to READY (Scheduler use of it)
  return (Tid_t) ptcb_new; // Return Tid_t of new PTCB
  
}

/**
  @brief Return the Tid of the current PTCB.
 */
Tid_t sys_ThreadSelf()
{
	return (Tid_t) cur_thread()->ptcb;
}

/**
  @brief Join the given PTCB-Thread.
  
  First cast the Tid into PTCB. Then checks the following:\n 
  1) PTCB exists in CURPOC's ptcb list\n 
  2) Given Tid isn't the current thread\n 
  3) PTCB that we want to join isn't exited\n 

  If any above is false, don't join

  After that Thread waits while PTCB_to_join exit or detached
  If PTCB_to_join get detached then dont save its exitval

  @param tid The ID of the thread to get joined
  @param exitval The space to save its exit value
  @returns 0 if given PTCB joined successfully and exited
  @returns -1 in case of fault check or get detached during waiting time
  */
int sys_ThreadJoin(Tid_t tid, int* exitval)
{
  PTCB* ptcb_to_join = (PTCB*) tid;

  if(rlist_find(&CURPROC->ptcb_list, ptcb_to_join, NULL) != NULL && tid != sys_ThreadSelf() && ptcb_to_join->detached == 0) { /**< Checks*/

    ptcb_to_join->refcount++; //Increase ref counter by 1

    while (ptcb_to_join->exited != 1 && ptcb_to_join->detached != 1) // Wait till new ptcb is exited or detached.
    {
      kernel_wait(&ptcb_to_join->exit_cv, SCHED_USER);
    }

    ptcb_to_join->refcount--; // Since get detached or exited, decrease ref counter

    if(ptcb_to_join->detached != 0) // If get detached dont return the exit value
      return -1;

    if(exitval!= NULL ) // exitval save 
      *exitval = ptcb_to_join->exitval;

    if(ptcb_to_join->refcount == 0){ // If PTCB exited and no other thread waits it then remove from PTCB list and set free.
      rlist_remove(&ptcb_to_join->ptcb_list_node); 
      free(ptcb_to_join);
    }
    return 0;
  }
  return -1;
}

/**
  @brief Detach the given thread.

  Make checks:\n 
  1)Given tid isn't NOTHREAD\n 
  2)PTCB exists in the list of current process.\n 
  3)ptcb that will get detached isn't exited.\n 

  If the above are true then set the ptcb to detached and wake-up the waiting threads.

  @param tid The Tid of the ptcb to detach
  @returns 0 if detached successfully
  @returns 1 if checks faild
  */
int sys_ThreadDetach(Tid_t tid)
{
  PTCB* ptcb_to_detach = (PTCB*) tid;

  if(tid != NOTHREAD && rlist_find(& CURPROC->ptcb_list, ptcb_to_detach, NULL) != NULL && ptcb_to_detach->exited == 0){ // Checks
    ptcb_to_detach->detached = 1; // Set ptcb to detached
    kernel_broadcast(&ptcb_to_detach->exit_cv); // Wake up Threads
    return 0;
  }else{
    return -1;
  }
}

/**
  @brief Terminate the current thread.

  When this function is called by a process thread, the thread exits and sets its exit code to @c exitval.
  Then wake all the threads that waited it  
  
  If the exited thread is the main thread then the current process terminates by:\n 
  1)Reparent any children of the exiting process to the initial task\n 
  2)Add exited children to the initial task's exited list and signal the initial task\n
  3)Put me (process) into my parent's exited list\n
  4)Clean up process data and chance state\n
  5)Call kernel_sleep()

  @param exitval the exit status of the process
  @Exit
  */
void sys_ThreadExit(int exitval)
{

  PTCB* ptcb = (PTCB*) sys_ThreadSelf();
      
  ptcb->exited = 1;
  ptcb->exitval = exitval;
  kernel_broadcast(&ptcb->exit_cv);

  PCB* curproc = CURPROC;
  curproc->thread_count--;
  if ( curproc->thread_count == 0){

    if (get_pid(curproc)!=1){

    /* Reparent any children of the exiting process to the
       initial task */
      PCB* initpcb = get_pcb(1);
      while(!is_rlist_empty(& curproc->children_list)) {
        rlnode* child = rlist_pop_front(& curproc->children_list);
        child->pcb->parent = initpcb;
        rlist_push_front(& initpcb->children_list, child);
      }

      /* Add exited children to the initial task's exited list
         and signal the initial task */
      if(!is_rlist_empty(& curproc->exited_list)) {
        rlist_append(& initpcb->exited_list, &curproc->exited_list);
        kernel_broadcast(& initpcb->child_exit);
      }

      /* Put me into my parent's exited list */
      rlist_push_front(& curproc->parent->exited_list, &curproc->exited_node);
      kernel_broadcast(& curproc->parent->child_exit);
    }

    assert(is_rlist_empty(& curproc->children_list));
    assert(is_rlist_empty(& curproc->exited_list));
    /*
      Do all the other cleanup we want here, close files etc.
     */

    /* Release the args data */
    if(curproc->args) {
      free(curproc->args);
      curproc->args = NULL;
    }

    /* Clean up FIDT */
    for(int i=0;i<MAX_FILEID;i++) {
      if(curproc->FIDT[i] != NULL) {
        FCB_decref(curproc->FIDT[i]);
        curproc->FIDT[i] = NULL;
      }
    }

    /* Disconnect my main_thread */
    curproc->main_thread = NULL;

    /* Now, mark the process as exited. */
    curproc->pstate = ZOMBIE;
  }
  /* Bye-bye cruel world */
  kernel_sleep(EXITED, SCHED_USER);
}

/**
  @brief PTCB space allocation and basic initializations

  @param task the task to save in PTCB
  @param argl the argl to save in PTCB
  @param args the args to save in PTCB
  @returns A pointer to the initialized PTCB     
*/
PTCB* new_ptcb(Task task, int argl, void* args){
	PTCB*	ptcb = xmalloc(sizeof(PTCB));  // Space allocation of the new ptcb
  // Initialize the ptcb's fileds here.
	ptcb->exited=0;
	ptcb->detached=0;
	ptcb->task=task;
	ptcb->argl=argl;
  ptcb->refcount=0;
  ptcb->exit_cv = COND_INIT;
	if(args!=NULL){
		ptcb->args=args;
	}
	else{ptcb->args=NULL;}

	rlnode_init(&ptcb->ptcb_list_node,ptcb);  // Initialisation of ptcb_list_node
  return ptcb;
}

/** @} */
