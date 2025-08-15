package Honey;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;


public class Bee extends Thread {
	String serverIp;
	int port;
	
	int id;
	public Bee(String serverIp, int port, int id) {
		this.id = id;
		this.serverIp = serverIp;
		this.port = port;
	}

	public void run() {
		for (; ; ) {
			try {
				Thread.sleep((long) (Math.random()*1000));
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try (Socket socket = new Socket(serverIp,port);
					InputStream is = socket.getInputStream();
					BufferedReader r = new BufferedReader(new InputStreamReader(is));
					OutputStream os = socket.getOutputStream();
					PrintWriter w = new PrintWriter(new OutputStreamWriter(os), true);
					){
				
					System.out.println("Putting " + id);
					w.println("put");
					System.out.println("Bee: " + r.readLine() + " - Bear sleeps.");
	
			} catch (Exception e) {
				System.out.println(e);
				System.out.println("Bee finished.");
				//System.err.println(e);
				return;
			}
		}
		//
	}


	public static void main(String[] args) throws IOException {
		

//		InputStreamReader input = new InputStreamReader(System.in);
//		BufferedReader reader = new BufferedReader(input);
//		System.out.println( reader.readLine());
		
	}
}
