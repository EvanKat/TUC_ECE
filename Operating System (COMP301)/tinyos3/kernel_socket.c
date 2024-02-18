#include "kernel_cc.h"
#include "tinyos.h"
#include "kernel_socket.h"

/*	The function that Read() uses to get data from a socket	
	Arguments:
	-scb_t pointer to an SCB object
	-buf buffer to return the data by reference
	-size to know how many bytes to read 
*/
int socket_read(void* scb_t, char *buf, unsigned int size){
	SCB* scb=(SCB*) scb_t;
	/* We need the SCB to exist and be a peer socket*/
	if(scb == NULL ||scb->type != SOCKET_PEER)
		return -1;

	return pipe_read(scb->peer_s.read_pipe, buf, size);
}

/*	The function that Write() uses to write data in a socket	
	Arguments:
	-scb_t pointer to an SCB object
	-buf buffer to get data by reference
	-size to know how many bytes to write from the buffer 
*/
int socket_write(void* scb_t, const char *buf, unsigned int size){
	SCB* scb=(SCB*) scb_t;
	if(scb == NULL || scb->type != SOCKET_PEER)
		return -1;

	return pipe_write(scb->peer_s.write_pipe, buf, size);
}

/*	Close the socket(stop anyone from reading or writing).
	Arguments:
	-scb_t pointer to an SCB object
*/	
int socket_close(void* scb_t){
	SCB* scb=(SCB*) scb_t;

	if(scb == NULL)
		return -1;
	/*	Handle each SCB according to its type */
	switch(scb->type){
		case SOCKET_LISTENER:
			while(rlist_len(&scb->listen_s.queue) != 0){  /*While it still has requests*/
				rlnode* trash = rlist_pop_front(&scb->listen_s.queue); /* pop one request */
				free(trash);  /* free the allocated space */
			}
			PORT_MAP[scb->port] = NULL;  /* free the space in the PORT_MAP */
			scb->port = NOPORT;  
			kernel_signal(&scb->listen_s.req_available);  // if we close the stream while someone
			break;										  // is sleeping on our condition variable(see Connect())
		case SOCKET_PEER:
			pipe_reader_close(scb->peer_s.read_pipe);  // just close the pipes
			pipe_writer_close(scb->peer_s.write_pipe);
			break;
		default:
			break;
	}

	/* Decrement refcount of the SCB, to know when to delete it*/
	scb->refcount--;
	if (scb->refcount < 0)
		free(scb);

	return 0;
}

static file_ops socketOperations = {
	.Open = NULL,
	.Read = socket_read,
	.Write = socket_write,
	.Close = socket_close
};

// Allocate, initialize and return a new socket control block
SCB* new_socket(port_t p){
	// Allocation of space
	SCB* socket=(SCB*)xmalloc(sizeof(SCB));
	// Initialization
	socket->refcount = 0;
	socket->port = p;
	socket->type = SOCKET_UNBOUND;  /* at the beginning of its little life, it is unbound*/
	return socket;
}

/* Returns the pointer to SCB from a file id */
SCB* get_scb(Fid_t sock){
	FCB* socket_fcb = get_fcb(sock);  /* returns pointer to an FCB */

	if(socket_fcb == NULL)
		return NULL;
	else
		return (SCB*)socket_fcb->streamobj;
}

/**
	@brief Return a new socket bound on a port.
	This function returns a file descriptor for a new
	socket object.	If the @c port argument is NOPORT, then the 
	socket will not be bound to a port. Else, the socket
	will be bound to the specified port. 
	@param port The port the new socket will be bound to
	@returns A file id for the new socket, or NOFILE on error. Possible
		reasons for error:
		- the port is iilegal
		- the available file ids for the process are exhausted
*/
Fid_t sys_Socket(port_t port)
{	
	/* In case of an invalid port, return error */
	if(port < 0 || port > MAX_PORT){
		return NOFILE;
	}

	Fid_t fid;
	FCB* fcb;

	// Allocate and link an FCB with a file id */
	if(!FCB_reserve(1, &fid, &fcb))
		return NOFILE;

	SCB* socket = new_socket(port);
	// Initialization
	socket->fcb = fcb;
	socket->fcb->streamobj = socket;
	socket->fcb->streamfunc = &socketOperations;

	// Fid through FCB_reserve 
	return fid;
}

/**
	@brief Initialize a socket as a listening socket.
	A listening socket is one which can be passed as an argument to
	@c Accept. Once a socket becomes a listening socket, it is not
	possible to call any other functions on it except @c Accept, @Close
	and @c Dup2().
	The socket must be bound to a port, as a result of calling @c Socket.
	On each port there must be a unique listening socket (although any number
	of non-listening sockets are allowed).
	@param sock the socket to initialize as a listening socket
	@returns 0 on success, -1 on error. Possible reasons for error:
		- the file id is not legal
		- the socket is not bound to a port
		- the port bound to the socket is occupied by another listener
		- the socket has already been initialized
	@see Socket
 */
int sys_Listen(Fid_t sock)
{
	// Get the CURPROCS SCB
	SCB* socket = get_scb(sock);

	// Checks
	if(socket == NULL || socket->type != SOCKET_UNBOUND || socket->port < 1 || socket->port > MAX_PORT || PORT_MAP[socket->port] != NULL)
		return -1;
	
	// Mark the socket as Listener
	socket->type = SOCKET_LISTENER;
	// Link PORT_MAP with SCB 
	PORT_MAP[socket->port] = socket;

	// Initialize the Cond_Var of socket
	socket->listen_s.req_available = COND_INIT;
	// Initialize the header of the listeners queue
	rlnode_init(&socket->listen_s.queue, NULL);

	return 0;
}



/**
	@brief Wait for a connection.
	With a listening socket as its sole argument, this call will block waiting
	for a single @c Connect() request on the socket's port. 
	one which can be passed as an argument to @c Accept. 
	It is possible (and desirable) to re-use the listening socket in multiple successive
	calls to Accept. This is a typical pattern: a thread blocks at Accept in a tight
	loop, where each iteration creates new a connection, 
	and then some thread takes over the connection for communication with the client.
	@param sock the socket to initialize as a listening socket
	@returns a new socket file id on success, @c NOFILE on error. Possible reasons 
	    for error:
		- the file id is not legal
		- the file id is not initialized by @c Listen()
		- the available file ids for the process are exhausted
		- while waiting, the listening socket @c lsock was closed
	@see Connect
	@see Listen
 */
Fid_t sys_Accept(Fid_t lsock)
{

	SCB* listener = get_scb(lsock);

	// Checks
	if(listener == NULL || listener->type != SOCKET_LISTENER)
		return NOFILE;

	listener->refcount++;

	// While queue of request is empty and listener port is NOPORT, wait 
	// if listener->port == NOPORT , it means that it's closed(see socket_close())
	while (rlist_len(&listener->listen_s.queue) == 0 && listener->port != NOPORT){ 
		kernel_wait(&listener->listen_s.req_available, SCHED_PIPE);
	}

	// If listener port is NOPORT (e.g. closed), then fail
	if (listener->port == NOPORT)
		return NOFILE;

	// Take the 1st waiting connection request
	rlnode* request = rlist_pop_front(&listener->listen_s.queue);
	// The connection request that waited to connect
	c_req* c_req = request->c_req;

	// The fid that points to the newly created unbound server socket
	Fid_t serv_fid = sys_Socket(listener->port);
	
	// Server SCB
	SCB* server_scb = get_scb(serv_fid);
	// In case of failed construction of socket
	if (server_scb == NULL)
		return NOFILE;

	// Set the type of server to peer(it was unbound)
	server_scb->type = SOCKET_PEER;
	// Get the pointer to the requester Socket 
	SCB* client_scb = c_req->peer;
	// Set the type of client (requester socket)
	client_scb->type = SOCKET_PEER;

    // connect peers  with each other(remember: they are not network sockets)
	server_scb->peer_s.peer = client_scb;
	client_scb->peer_s.peer = server_scb;

	// Initialise da pipes
	Pipe_CB* p1 = pipe_init();
	Pipe_CB* p2 = pipe_init();

	// Connect pipe1 
	p1->writer = server_scb->fcb;
	p1->reader = client_scb->fcb;
	
	// Connect pipe2
	p2->writer = client_scb->fcb;
	p2->reader = server_scb->fcb;

	// Set the functions of Server<->Client sockets
	server_scb->fcb->streamfunc = &socketOperations;
	client_scb->fcb->streamfunc = &socketOperations;

	// Connect server socket with pipes
	server_scb->peer_s.write_pipe = p1;  // write pipe = pointer to pipe_CB
	server_scb->peer_s.read_pipe = p2;

	// Connect client socket with pipes
	client_scb->peer_s.read_pipe = p1;
	client_scb->peer_s.write_pipe = p2;

	// Requester admitted, to tell the owner of the request that it has been admitted
	c_req->admitted=1;

	// One request passed
	listener->refcount--;

	/* If nobody needs the listener socket, there is no meaning in its life... */
	if (listener->refcount < 0) 
	 	free(listener);


	//wake up whoever sleeps in the listener condvar(connect sleeps there)
	kernel_signal(&listener->listen_s.req_available);
	return serv_fid;
}

/**
	@brief Create a connection to a listener at a specific port.
	Given a socket @c sock and @c port, this call will attempt to establish
	a connection to a listening socket on that port. If sucessful, the
	@c sock stream is connected to the new stream created by the listener.
	The two connected sockets communicate by virtue of two pipes of opposite directions, 
	but with one file descriptor servicing both pipes at each end.
	The connect call will block for approximately the specified amount of time.
	The resolution of this timeout is implementation specific, but should be
	in the order of 100's of msec. Therefore, a timeout of at least 500 msec is
	reasonable. If a negative timeout is given, it means, "infinite timeout".
	@params sock the socket to connect to the other end
	@params port the port on which to seek a listening socket
	@params timeout the approximate amount of time to wait for a
	        connection.
	@returns 0 on success and -1 on error. Possible reasons for error:
	   - the file id @c sock is not legal (i.e., an unconnected, non-listening socket)
	   - the given port is illegal.
	   - the port does not have a listening socket bound to it by @c Listen.
	   - the timeout has expired without a successful connection.
*/
int sys_Connect(Fid_t sock, port_t port, timeout_t timeout)
{	
	// Get the pointer to our SCB struct from the Fid_t argument
	SCB* socket = get_scb(sock);  

	if(socket == NULL || socket->type != SOCKET_UNBOUND || port > MAX_PORT || port < 1 || PORT_MAP[port] == NULL  || PORT_MAP[port]->type != SOCKET_LISTENER){
		return -1;
	}
	// Increase refcount of SCB
	socket->refcount++;
	
	//Build the connection request c_req
	c_req* request = xmalloc(sizeof(c_req));
	request->admitted = 0;
	// Point to the parent peer 
	request->peer = socket; 
	request->connected_cv = COND_INIT;
	//initialise the rlnode of the request to point to itself(intrusive lists u know)
	rlnode_init(&request->queue_node, &request);


	SCB* listener_scb = PORT_MAP[port];
	// Add the request to the listener's request list
	rlist_push_back(&listener_scb->listen_s.queue, &request->queue_node);
	// Signal the listener SCB that there is a request to handle!
	kernel_signal(&listener_scb->listen_s.req_available); 

	
	timeout_t timeout_result;  
	//the connect() function waits in the condvar of the listener
	//When the accept() accepts the request, it has to signal that condition variable
	//to begin the data exchange.
	//sleep on the listener's condvar for a specified amount of time(when he accept()'s us, he will wake us up)
	timeout_result = kernel_timedwait(&listener_scb->listen_s.req_available, SCHED_PIPE, timeout);

	if (timeout_result==0){
		// the above condition satisfied means that the kernel wait was timed out
		// so we remove the request from the listener scb list and free its space
		rlist_remove(&request->queue_node);
		free(request);
		return -1;  // we failed to pass the request(it wasn't admitted)
	}


	//decrease socket refcount
	socket->refcount--;
	if (socket->refcount < 0)
		free(socket);

	return 0;
}



/**
   @brief Shut down one direction of socket communication.
   With a socket which is connected to another socket, this call will 
   shut down one or the other direction of communication. The shut down
   of a direction has implications similar to those of a pipe's end shutdown.
   More specifically, assume that this end is socket A, connected to socket
   B at the other end. Then,
   - if `ShutDown(A, SHUTDOWN_READ)` is called, any attempt to call `Write(B,...)`
     will fail with a code of -1.
   - if ShutDown(A, SHUTDOWN_WRITE)` is called, any attempt to call `Read(B,...)`
     will first exhaust the buffered data and then will return 0.
   - if ShutDown(A, SHUTDOWN_BOTH)` is called, it is equivalent to shutting down
     both read and write.
   After shutdown of socket A, the corresponding operation `Read(A,...)` or `Write(A,...)`
   will return -1.
   Shutting down multiple times is not an error.
   
   @param sock the file ID of the socket to shut down.
   @param how the type of shutdown requested
   @returns 0 on success and -1 on error. Possible reasons for error:
       - the file id @c sock is not legal (a connected socket stream).
*/

// typedef enum {
//   SHUTDOWN_READ=1,    /**< Shut down the read direction. */
//   SHUTDOWN_WRITE=2,   *< Shut down the write direction. 
//   SHUTDOWN_BOTH=3     /**< Shut down both directions. */
// } shutdown_mode;

int sys_ShutDown(Fid_t sock, shutdown_mode how)
{

	SCB* socket_cb = get_scb(sock);

	if( socket_cb == NULL || socket_cb->type != SOCKET_PEER)
		return -1;

	int ret;  /*the return value*/

		switch(how){
		case SHUTDOWN_READ:
			if(!(ret = pipe_reader_close(socket_cb->peer_s.read_pipe)))
				socket_cb->peer_s.read_pipe = NULL;
			return ret;
		case SHUTDOWN_WRITE:
			if(!(ret = pipe_writer_close(socket_cb->peer_s.write_pipe)))
				socket_cb->peer_s.write_pipe = NULL;
			return ret;
		case SHUTDOWN_BOTH:
			if(!(ret = ( pipe_reader_close(socket_cb->peer_s.read_pipe) && pipe_writer_close(socket_cb->peer_s.write_pipe)))){
				socket_cb->peer_s.write_pipe = NULL;
				socket_cb->peer_s.read_pipe = NULL;
			}
			return ret;
		default:
			return -1;
	}

	return -1;
}

/*
// A function to decrement the refcount SCB counter and 
// delete/free the space if no one points to the arg SCB
void decref_SCB(SCB * socket_cb){
	socket_cb->refcount--;
	//If therefcount == 0, do one of three cases:
	if(socket_cb->refcount == 0){
		if(socket_cb->type == SOCKET_PEER){ // if its a non-reffered-anywhered peer, it has no purpose
			free(socket_cb->s_type.peer_s);
			free(socket_cb);
			}
		if(socket_cb->type == SOCKET_UNBOUND)
			free(socket_cb);
		if(socket_cb->type == SOCKET_LISTENER){
			free(socket_cb->sa_type.listen_s);
			free(socket_cb);
		}
	}
}
*/
