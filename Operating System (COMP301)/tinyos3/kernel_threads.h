#include "tinyos.h"
#include "kernel_sched.h"
#include "kernel_proc.h"

PTCB* new_ptcb(Task task, int argl, void* args);

void rcdec(PTCB* ptcb);

void rcinc(PTCB* ptcb);
