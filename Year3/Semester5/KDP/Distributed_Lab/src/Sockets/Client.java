package Sockets;

import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.ObjectOutputStream.PutField;
import java.net.Socket;
 
public class Client {
	public static void main(String[] args) {
		try (Socket server = new Socket("localhost",12600);
			 OutputStream os=server.getOutputStream();
			 PrintWriter pout = new PrintWriter(os, true);
			){
			System.out.println("Klijent");
			pout.print("Alo brate");
			System.out.println("Kraj");
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
}
