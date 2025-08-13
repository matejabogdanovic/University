package rs.ac.bg.etf.kdp.net.thread;

import java.net.Socket;

import rs.ac.bg.etf.kdp.net.Buffer;

public class BufferWorkingThread extends WorkingThread {

	protected Buffer<Socket> buffer;

	public BufferWorkingThread(int id, Buffer<Socket> buffer, String protocol) {
		super(id, null, protocol);
		this.buffer = buffer;
		this.protocolName = protocol;
	}

	@Override
	public void run() {
		while (true) {
			work();
		}
	}

	@Override
	public Socket getClient() {
		return buffer.get();
	}
}
