package rs.ac.bg.etf.kdp.net.buffer;

import java.util.ArrayList;
import java.util.List;

import rs.ac.bg.etf.kdp.net.Buffer;

public class ArrayBuffer<T> implements Buffer<T> {

	private int capacity;
	protected List<T> arrayBuffer;

	public ArrayBuffer() {
		this(MAXBUFFERSIZE);
	}

	public ArrayBuffer(int newCapacity) {
		if ((newCapacity > 0) && (newCapacity <= MAXBUFFERSIZE))
			capacity = newCapacity;
		else
			capacity = MAXBUFFERSIZE;
		arrayBuffer = new ArrayList<T>();
	}

	@Override
	public synchronized T get() {
		while (arrayBuffer.size() == 0) {
			try {
				wait();
			} catch (InterruptedException ex) {
				ex.printStackTrace();
			}
		}
		T data = arrayBuffer.remove(0);
		notifyAll();
		return data;
	}

	@Override
	public synchronized void put(T value) {
		while (arrayBuffer.size() == capacity) {
			try {
				wait();
			} catch (InterruptedException ex) {
				ex.printStackTrace();
			}
		}
		arrayBuffer.add(value);
		notifyAll();
	}

	@Override
	public synchronized void remove(T data) {
		try {
			int index = arrayBuffer.indexOf(data);
			if (index < 0)
				return;
			arrayBuffer.remove(index);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	@Override
	public synchronized int size() {
		return arrayBuffer.size();
	}

	@Override
	public synchronized int capacity() {
		return capacity;
	}

}
