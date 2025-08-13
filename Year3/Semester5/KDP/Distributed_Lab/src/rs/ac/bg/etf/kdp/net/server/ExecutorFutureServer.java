package rs.ac.bg.etf.kdp.net.server;

import java.net.Socket;
import java.util.concurrent.Callable;
import java.util.concurrent.Future;

import rs.ac.bg.etf.kdp.net.thread.WorkingThread;

public class ExecutorFutureServer extends ExecutorServer {

	public ExecutorFutureServer(int num, String protocol, int port) {
		super(num, protocol, port);
	}

	@Override
	public void processRequest(final Socket client) {
		@SuppressWarnings("unused")
		Future<Void> future = pool.submit(new Callable<Void>() {

			@Override
			public Void call() {
				WorkingThread wt = new WorkingThread(0, client, protocol);
				wt.run();
				return null;
			}
		});

		// try {
		// future.get();
		// } catch (Exception ex) {
		// }
	}
}
