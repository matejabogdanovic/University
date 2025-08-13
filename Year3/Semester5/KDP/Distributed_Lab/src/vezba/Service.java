package vezba;

import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.net.Socket;



public class Service {
	String host;
    int port;

    public Service(String host, int port) {
        this.host = host;
        this.port = port;
    }

    public void eat(int id) {

    	try (Socket mySocket = new Socket(host ,port);
    			OutputStream os = mySocket.getOutputStream();
    			ObjectOutputStream writer = new ObjectOutputStream(os);
    				
    			InputStream is = mySocket.getInputStream();
    			ObjectInputStream reader = new ObjectInputStream(is);
    				){
    			System.out.println("Writing to eat: " + id);
    			writer.writeObject(new Request(id, "eat"));
    			Object res = reader.readObject();
    			Response response = (Response)res;
    			System.out.println("Philosopher" + id + " eating at " + response.time);
    		} catch (Exception e) {
    		
    			System.err.println(e);
    		}


    }
}
