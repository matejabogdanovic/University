package rmi;

import java.io.Serializable;
import java.rmi.RemoteException;

import java.rmi.server.UnicastRemoteObject;

public class RemoteObj extends UnicastRemoteObject implements RemoteInterface, Serializable {

	protected RemoteObj() throws RemoteException {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void print() throws RemoteException {
		System.out.println("Remote obj print.");
		
	}

}
