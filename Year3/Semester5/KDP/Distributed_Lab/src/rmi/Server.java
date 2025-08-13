package rmi;

import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

public class Server {

	
	
	public static void main(String[] args) {
		try {
			if (System.getSecurityManager() == null) {
			System.setSecurityManager(new SecurityManager());
			} // od verzije Java 17 SecurityManager je deprecated i ne koristi se
			
			
			MessageInterface message = new Message("Hej");
			MessageInterface stub = (MessageInterface) UnicastRemoteObject.exportObject(message, 0);
			String urlString = "/msg";
			
			Registry registry = LocateRegistry.createRegistry(9000);
			//Registry registry = LocateRegistry.getRegistry(port);
			registry.rebind(urlString, stub);
			System.out.println("Server is on");
			
			} catch (RemoteException e) {
				e.printStackTrace();
			}
	}
}
