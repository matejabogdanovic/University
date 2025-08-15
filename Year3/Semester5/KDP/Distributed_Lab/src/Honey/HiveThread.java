package Honey;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;

public class HiveThread extends Thread {
	Hive hive;
	Socket client;
	
	
	
	public HiveThread(Hive hive, Socket client) {
		this.hive = hive;
		this.client = client;
	}


	@Override
	public void run() {
		try (Socket socket = client;
				InputStream is = socket.getInputStream();
				BufferedReader r = new BufferedReader(new InputStreamReader(is));
				OutputStream os = socket.getOutputStream();
				PrintWriter w = new PrintWriter(new OutputStreamWriter(os), true);
				){
			
			//w.println("Medjed");
			String command = r.readLine();
			//System.out.println("Thread: " + command);
			if(command.equals("put")) {
				hive.put();
				w.println("Ok");
			}else if (command.equals("eat")) {
				hive.eat(w);
				// w.println("Ok");
			}else w.println("Invalid command.");
		} catch (Exception e) {
			System.err.println(e);
		}
	}
}
