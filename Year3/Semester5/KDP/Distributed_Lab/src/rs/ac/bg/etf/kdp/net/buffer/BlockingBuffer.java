package rs.ac.bg.etf.kdp.net.buffer;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

import rs.ac.bg.etf.kdp.net.Buffer;

public class BlockingBuffer<T> implements Buffer<T> {

	protected BlockingQueue<T> buffer;
	protected int capacity;

	public BlockingBuffer() {
		this(MAXBUFFERSIZE);
	}

	public BlockingBuffer(int capacity) {
		if ((capacity < 0) || (capacity > MAXBUFFERSIZE)) {
			capacity = MAXBUFFERSIZE;
		}
		buffer = new LinkedBlockingQueue<T>(capacity);
		this.capacity = capacity;
	}

	@Override
	public T get() {
		while (true) {
			try {
				return buffer.take();
			} catch (InterruptedException e) {
			}
		}
	}

	@Override
	public void put(T value) {
		while (true) {
			try {
				buffer.put(value);
				return;
			} catch (InterruptedException e) {
			}
		}
	}

	@Override
	public void remove(T data) {
		buffer.remove(data);
	}

	@Override
	public int size() {
		return buffer.size();
	}

	@Override
	public int capacity() {
		return capacity;
	}
}
