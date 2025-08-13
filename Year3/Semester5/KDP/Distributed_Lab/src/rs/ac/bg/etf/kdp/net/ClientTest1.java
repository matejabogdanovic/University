package rs.ac.bg.etf.kdp.net;

import java.net.Socket;

import rs.ac.bg.etf.kdp.net.thread.WorkingThread;

public class ClientTest1 {

	static final int port = 8080;
	static final String host = "127.0.0.1";
	static final String protocol = "ClientProtocolKnockKnock";

	public static void main(String[] args) {
		for (int i = 0; i < 10; i++) {
			try (Socket server = new Socket(host, port);) {
				System.out.println("Iteration " + i);
				WorkingThread wt = new WorkingThread(i, server, protocol);
				wt.run();
				Thread.sleep(500 + (int) (Math.random() * 1000));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
