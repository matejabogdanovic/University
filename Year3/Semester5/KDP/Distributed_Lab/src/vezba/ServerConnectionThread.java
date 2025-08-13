package vezba;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.Socket;

public class ServerConnectionThread extends Thread {
	private Socket client;
	private Server server;
	public ServerConnectionThread(Socket client, Server server) {
		this.client = client;
		this.server = server;
	}
	
	@Override
	public void run() {
		System.out.println("Server connection thread run.");
		try ( Socket c = this.client;
			OutputStream os = c.getOutputStream();
			ObjectOutputStream writer = new ObjectOutputStream(os);
				
			InputStream is = c.getInputStream();
			ObjectInputStream reader = new ObjectInputStream(is);
				) {
			System.out.println("Starting to read.");

				Object req = reader.readObject();
				Request request = (Request) req;
				
				if(request.operation.equals("eat")) {
					
					// server.startEating(request.id); // wait to start eating
					writer.writeObject(new Response(System.currentTimeMillis()));
					
				}else if(request.operation.equals("stop")) {
					// server.stopEating(request.id); // stop eating
					System.out.println("stop eating");
				}
				
			
		
				
		}catch (Exception e) {
			// TODO: handle exception
			System.out.println(e);
		}finally {
			System.out.println("Closing connection.");
		}
				
	} 
	
	
}
