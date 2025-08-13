package rs.ac.bg.etf.kdp.net;

import rs.ac.bg.etf.kdp.net.server.OneThreadServer;

public class ServerTest1 {

	static final int port = 8080;
	static final String protocol = "ServerProtocolKnockKnock";
	static final int numThreads = 10;

	public static void main(String[] args) {
		Server server = new OneThreadServer(protocol, port);
		// Server server = new MultiThreadsServer(protocol, port);
		// Server server = new BufferWorkingServer(numThreads, protocol, port);
		// Server server = new BufferServer(numThreads, protocol, port);
		// Server server = new ExecutorServer(numThreads,protocol, port);
		// Server server = new ExecutorFutureServer(numThreads, protocol, port);
		server.start();
	}
}
