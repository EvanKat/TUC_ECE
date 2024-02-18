#include "tinyos.h"
#include "kernel_streams.h"
/* Size of Buffer 16kB*/
#define PIPE_BUFFER_SIZE 16384

/**
  @brief Pipe Control Block.

  This structure holds all information pertaining to a Pipe.
 */
typedef struct pipe_control_block {
    /* Pointers to read/write from buffer*/
    FCB *reader, *writer;

    /* For blocking writer if no space is available*/
    CondVar has_space;
    /* For blocking reader until data are available*/ 
    CondVar has_data;
    /* Write and Read position in buffer*/
    int w_position, r_position;
    /* Bounded (cyclic) byte buffer*/
    char buffer[PIPE_BUFFER_SIZE];

    int word_length;
    
} Pipe_CB;

Pipe_CB* pipe_init();
int sys_Pipe(pipe_t* pipe);

int pipe_write(void* pipecb_t, const char *buf, unsigned int n);

int pipe_read(void* pipecb_t, char *buf, unsigned int n);

int pipe_writer_close(void* _pipecb);

int pipe_reader_close(void* _pipecb);
