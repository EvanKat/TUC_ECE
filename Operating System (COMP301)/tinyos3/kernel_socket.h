#include "tinyos.h"
#include "kernel_pipe.h"

/*	First we have 2 the ubound sockets 
	Then one become the LISTENER(1) socket through sys_Listen
	Then the other unbound socket(2) want to Connect with the LISTENER 

	If the (1) have lot of requests then the (2) goes and in the queue
	When time come (1)<---link--->(2) and both become peer_sockets
*/
// Forward declaration of SCB to get used at PEER_Socket
typedef struct Socket_Control_Block SCB;

// PORT Map table
SCB* PORT_MAP[MAX_PORT+1]={NULL};

typedef struct connection_request{
  int admitted; // a flag that shows if the connection request is already accepted or not
  SCB* peer;  //points to the socket that made the rekuest
  
  CondVar connected_cv;  
  rlnode queue_node;  // intrusive list node. Used in the queue rlnode in the listen SCB.
}c_req;

// New unbound socket 
typedef struct unbound_socket{
  rlnode unbound_socket;
}unbound_st;

// Listener Socket (Waits for connection)
typedef struct listener_socket{
  rlnode queue;
  CondVar req_available;
}listen_st;

// Connected sockets Listener<---link--->Unbound
typedef struct peer_socket{
  SCB* peer;
  Pipe_CB* write_pipe;
  Pipe_CB* read_pipe;
}peer_st;


// Socket type
typedef enum socket_type{
	SOCKET_UNBOUND,
	SOCKET_PEER,
	SOCKET_LISTENER
}S_type;

// Socket Control Block
typedef struct Socket_Control_Block{
	// Pointer to FCB reader an writete starts here
	FCB* fcb;
	// Reference counter (possible for listener socket)
	uint refcount;
	// Socket type
	enum socket_type type;
	// The port to bound
	port_t port;

	// Only one type of it 
	union {
		listen_st listen_s;
		unbound_st unbound_s;
		peer_st peer_s;
	};

}SCB;



// PORT Map table
SCB* PORT_MAP[MAX_PORT+1];

Fid_t sys_Socket(port_t port);

int sys_Listen(Fid_t sock);

Fid_t sys_Accept(Fid_t lsock);

int sys_Connect(Fid_t sock, port_t port, timeout_t timeout);

int sys_ShutDown(Fid_t sock, shutdown_mode how);

int socket_write(void* scb_t, const char *buf, unsigned int size);

int socket_read(void* scb_t, char *buf, unsigned int size);

int socket_close(void* scb_t);

