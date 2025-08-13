package rs.ac.bg.etf.kdp.net.server;

import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import rs.ac.bg.etf.kdp.net.Server;
import rs.ac.bg.etf.kdp.net.thread.WorkingThread;

public class ExecutorServer extends Server {

	public static final int MAXTHREADS = 10;

	protected ExecutorService pool;

	public ExecutorServer() {
		this(MAXTHREADS, "", DEFAULTPORT);
	}

	public ExecutorServer(int numOfThreads, String protocol, int port) {
		super(protocol, port);
		pool = Executors.newFixedThreadPool(numOfThreads);
	}

	@Override
	public void processRequest(Socket client) {
		pool.execute(new WorkingThread(0, client, protocol));
	}

	@Override
	public void stop() {
		super.close();
		pool.shutdown();
		try {
			if (!pool.awaitTermination(60, TimeUnit.SECONDS)) {
				pool.shutdownNow();
				if (!pool.awaitTermination(60, TimeUnit.SECONDS))
					System.err.println("Pool did not terminate");
			}
		} catch (InterruptedException ie) {
			pool.shutdownNow();
			Thread.currentThread().interrupt();
		}
	}
}
