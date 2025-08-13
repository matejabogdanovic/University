package rmi;

import java.rmi.AccessException;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.Iterator;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class Client extends Thread{
	int id;
	MessageInterface msg;
	public Client(int id, MessageInterface msg) {
		// TODO Auto-generated constructor stub
		this.id = id;
		this.msg = msg;
	}
	@Override
	public void run() {
		try {
			msg.setMessage(""+id);
			msg.getRemote().print();
			
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	public static void main(String[] args) {
		if (System.getSecurityManager() == null) {
			System.setSecurityManager(new SecurityManager());
			}
		String urlString = "/msg";
		Registry registry = null;
		try {
			registry = LocateRegistry.getRegistry("localhost", 9000);
		
			MessageInterface msg = (MessageInterface) registry.lookup(urlString);
		
			System.out.println();
			
			ExecutorService e = Executors.newFixedThreadPool(10);
			for (int i = 0; i < 1; i++) {
				
			
				e.execute(new Client(i,msg));
			
			}
			
			 e.shutdown(); // Disable new tasks from being submitted
			   try {
			     // Wait a while for existing tasks to terminate
			     if (!e.awaitTermination(60, TimeUnit.SECONDS)) {
			       e.shutdownNow(); // Cancel currently executing tasks
			       // Wait a while for tasks to respond to being cancelled
			       if (!e.awaitTermination(60, TimeUnit.SECONDS))
			           System.err.println("Pool did not terminate");
			     }
			   } catch (InterruptedException ex) {
			     // (Re-)Cancel if current thread also interrupted
			     e.shutdownNow();
			     // Preserve interrupt status
			     Thread.currentThread().interrupt();
			   }
		} catch (Exception e) {
			System.err.println(e);
		}
	}
}
