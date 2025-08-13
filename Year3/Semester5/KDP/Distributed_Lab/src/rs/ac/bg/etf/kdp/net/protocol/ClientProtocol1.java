package rs.ac.bg.etf.kdp.net.protocol;

import rs.ac.bg.etf.kdp.net.communicator.Communicator;
import rs.ac.bg.etf.kdp.net.data.TextMessage;

public class ClientProtocol1 extends OneCommunicatorProtocol {

	public ClientProtocol1() {
	}

	public ClientProtocol1(Communicator communicator) {
		this.communicator = communicator;
	}

	@Override
	public void conversation() {

		try (Communicator communicator = getCommunicator();) {
			communicator.writeString("Hello!");
			System.out.println("Sent Hello!");

			String response = communicator.readString();
			System.out.println("Received " + response);
			TextMessage msg = new TextMessage("Message tekst " + response);
			communicator.writeObject(msg);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

}
