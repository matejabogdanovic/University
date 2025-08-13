package rs.ac.bg.etf.kdp.net.server;

import java.net.Socket;

import rs.ac.bg.etf.kdp.net.Server;
import rs.ac.bg.etf.kdp.net.thread.WorkingThread;

public class OneThreadServer extends Server {

	public OneThreadServer() {
		super();
	}

	public OneThreadServer(int port) {
		super(port);
	}

	public OneThreadServer(String protocol, int port) {
		super(protocol, port);
	}

	@Override
	public void processRequest(Socket client) {
		try {
			WorkingThread wt = new WorkingThread(nextId(), client, protocol);
			wt.run();
		} catch (Exception ex) {
		}
	}
}
