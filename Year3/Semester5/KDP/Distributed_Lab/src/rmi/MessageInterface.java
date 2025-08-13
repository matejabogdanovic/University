package rmi;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface MessageInterface extends Remote {
	
	public String getMessage() throws RemoteException;

	public void setMessage(String message) throws RemoteException;
	
	public RemoteInterface getRemote() throws RemoteException;
	
}
