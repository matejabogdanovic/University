package Sockets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

public class Sockets1 {
	
	public static void main(String[] args) {
		try(ServerSocket serverSocket = new ServerSocket(12600);
			Socket clientSocket =serverSocket.accept();
			InputStream is = clientSocket.getInputStream();
			BufferedReader reader = new BufferedReader(new InputStreamReader(is));
			) {
			
			System.out.println("Server");
			String s;
			while ((s = reader.readLine())!=null) {
				System.out.println(s);
			}
			System.out.println("Server kraj.");
		
		} catch (IOException e) {
			
			e.printStackTrace();
		}
	}
	
	
//	public static void main(String[] args) {
//		try(ServerSocket serverSocket = new ServerSocket(10000);
//			Socket clientSocket =serverSocket.accept();
//			InputStream is = clientSocket.getInputStream();
//			//BufferedReader reader = new BufferedReader(new InputStreamReader(is));
//			) {
//			
//			System.out.println("Server");
//			
//			while (true) {
//				int i = is.read();
//				if(i==-1)break;
//				System.out.println((char)i);
//			}
//			System.out.println("Server kraj.");
//		
//		} catch (IOException e) {
//			
//			e.printStackTrace();
//		}
//	}
}
