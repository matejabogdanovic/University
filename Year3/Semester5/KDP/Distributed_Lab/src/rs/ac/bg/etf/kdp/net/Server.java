package rs.ac.bg.etf.kdp.net;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public abstract class Server implements Runnable {

	private static int id = 0;

	public static final int DEFAULTPORT = -1;
	public static final String DEFAULTPROTOCOL = "ServerProtocol1";

	protected String protocol;
	protected String host;
	protected int port;

	public Server() {
		this(DEFAULTPROTOCOL, DEFAULTPORT);
	}

	public Server(int port) {
		this(DEFAULTPROTOCOL, port);
	}

	public Server(String protocol, int port) {
		this.port = port;
		this.protocol = protocol;
		thread = null;
		running = false;
	}

	ServerSocket listener = null;

	@Override
	public void run() {
		try {
			listener = new ServerSocket(port);
			while (running) {
				Socket client = listener.accept();
				processRequest(client);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			close();
		}
	}

	public abstract void processRequest(Socket client);

	protected volatile Thread thread;
	protected volatile boolean running;

	public void start() {
		if (thread == null) {
			thread = new Thread(this, "Server");
			running = true;
			thread.start();
		}
	}

	public void stop() {
		running = false;
		thread.interrupt();
		close();
	}

	public void close() {
		try {
			listener.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public boolean isRunning() {
		return running;
	}

	public static synchronized int nextId() {
		return id++;
	}
}
