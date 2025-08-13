package rmi;

import java.rmi.RemoteException;

public class Message implements MessageInterface {
	//private static final long serialVersionUID = 1L;
	String message;
	
	public Message(String message) {

		this.message = message;
	}

	public String getMessage() {
		return message;
	}

	public synchronized  void  setMessage(String message) {
		this.message = message;
		System.out.println("Poruka je "+ message);
	}

	@Override
	public RemoteInterface getRemote() throws RemoteException {
		return new RemoteObj();
	}
	
	
}
