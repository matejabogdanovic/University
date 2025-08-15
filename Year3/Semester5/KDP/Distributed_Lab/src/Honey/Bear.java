package Honey;

import java.awt.font.NumericShaper.Range;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Writer;
import java.net.Socket;
import java.util.Iterator;
import java.util.Random;


public class Bear extends Thread {
	String serverIp;
	int port;
	
	public Bear(String serverIp, int port) {
		this.serverIp = serverIp;
		this.port = port;
	}

	public void run() {
		for (int i = 0; i < 5; i++) {
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
				
					System.out.println("Bear will try to eat.");
					w.println("eat");
					System.out.println("Bear: " + r.readLine() + " - Bear sleeps.");
//					w.println("sleep");
//					System.out.println("Bear: " + r.readLine() + " - Bear woke up.");
	//				String command = r.readLine();
	//				System.out.println("Bear woked up by message: "+ command);
				
			} catch (Exception e) {
				System.err.println(e);
				System.out.println("Bear finished.");
				return;
			}
			
		}
	}


	public static void main(String[] args) throws IOException {

			

//		InputStreamReader input = new InputStreamReader(System.in);
//		BufferedReader reader = new BufferedReader(input);
//		System.out.println( reader.readLine());
		
	}
}
