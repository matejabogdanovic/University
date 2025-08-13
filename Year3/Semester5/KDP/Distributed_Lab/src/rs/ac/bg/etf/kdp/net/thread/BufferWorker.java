package rs.ac.bg.etf.kdp.net.thread;

import java.util.concurrent.BlockingQueue;

public class BufferWorker extends Thread {

	BlockingQueue<Runnable> buffer;
	private volatile boolean running;

	public BufferWorker(int id, BlockingQueue<Runnable> buffer) {
		super("BufferWorker" + id);
		this.buffer = buffer;
		this.running = true;
	}

	@Override
	public void run() {
		try {
			while (running) {
				Runnable r = buffer.take();
				r.run();
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	public void shutdown() {
		this.running = false;
		this.interrupt();
	}
}
