package rs.ac.bg.etf.kdp.net.protocol;

import java.io.BufferedReader;
import java.io.InputStreamReader;

import rs.ac.bg.etf.kdp.net.communicator.Communicator;

public class ClientProtocolKnockKnock extends OneCommunicatorProtocol {

	public static String byeAnswer = "Zdravo!";

	public ClientProtocolKnockKnock() {
		super();
	}

	@Override
	public void conversation() {
		String fromServer = "";
		String fromUser = "";
		try (Communicator communicator = getCommunicator();) {
			BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));
			System.out.print("Klijent: ");
			fromUser = stdIn.readLine();
			communicator.writeString(fromUser);
			while ((fromServer = communicator.readString()) != null) {
				System.out.println("Server: " + fromServer);
				if (fromServer.equals(byeAnswer))
					break;
				System.out.print("Klijent: ");
				fromUser = stdIn.readLine();
				if (fromUser != null) {
					communicator.writeString(fromUser);
				}
			}
			System.out.println("----------------------------");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
