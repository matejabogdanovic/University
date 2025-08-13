package rs.ac.bg.etf.kdp.net.server;

import java.net.Socket;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

import rs.ac.bg.etf.kdp.net.Server;
import rs.ac.bg.etf.kdp.net.thread.BufferWorker;
import rs.ac.bg.etf.kdp.net.thread.WorkingThread;

public class BufferServer extends Server {

	public static final int MAXTHREADS = 10;

	protected BlockingQueue<Runnable> buffer;
	protected List<BufferWorker> threads;

	public BufferServer() {
		this(MAXTHREADS, "", DEFAULTPORT);
	}

	public BufferServer(String protocol, int port) {
		this(MAXTHREADS, protocol, port);
	}

	public BufferServer(int num, String protocol, int port) {
		super(port);
		// 2 * num empirical factor
		buffer = new ArrayBlockingQueue<Runnable>(2 * num);

		threads = new LinkedList<BufferWorker>();
		for (int i = 0; i < num; i++) {
			BufferWorker bw = new BufferWorker(i, buffer);
			bw.setDaemon(true);
			bw.start();
			threads.add(bw);
		}
	}

	@Override
	public void processRequest(Socket client) {
		try {
			buffer.put(new WorkingThread(nextId(), client, protocol));
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void stop() {
		super.stop();
		buffer.clear();
		for (BufferWorker bw : threads) {
			bw.shutdown();
		}
	}
}
