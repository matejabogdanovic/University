package rs.ac.bg.etf.kdp.net.server;

import java.net.Socket;

import rs.ac.bg.etf.kdp.net.Server;
import rs.ac.bg.etf.kdp.net.thread.WorkingThread;

public class MultiThreadsServer extends Server {

	public MultiThreadsServer() {
		super();
	}

	public MultiThreadsServer(int port) {
		super(port);
	}

	public MultiThreadsServer(String protocol, int port) {
		super(protocol, port);
	}

	@Override
	public void processRequest(Socket client) {
		new WorkingThread(nextId(), client, protocol).start();
	}

}
