package rs.ac.bg.etf.kdp.net.server;

import java.net.Socket;

import rs.ac.bg.etf.kdp.net.Buffer;
import rs.ac.bg.etf.kdp.net.Server;
import rs.ac.bg.etf.kdp.net.buffer.ArrayBuffer;
import rs.ac.bg.etf.kdp.net.thread.BufferWorkingThread;
import rs.ac.bg.etf.kdp.net.thread.WorkingThread;

public class BufferWorkingServer extends Server {

	public static final int MAXTHREADS = 10;
	protected Buffer<Socket> buffer;

	public BufferWorkingServer(int num, String protocol, int port) {
		super(port);
		buffer = new ArrayBuffer<Socket>();
		for (int i = 0; i < num; i++) {
			WorkingThread t = new BufferWorkingThread(i, buffer, protocol);
			t.setDaemon(true);
			t.start();
		}
	}

	@Override
	public void processRequest(Socket client) {
		buffer.put(client);
	}

}
