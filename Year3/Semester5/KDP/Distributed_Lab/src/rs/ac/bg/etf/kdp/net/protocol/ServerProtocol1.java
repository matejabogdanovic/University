package rs.ac.bg.etf.kdp.net.protocol;

import rs.ac.bg.etf.kdp.net.communicator.Communicator;
import rs.ac.bg.etf.kdp.net.data.TextMessage;

public class ServerProtocol1 extends OneCommunicatorProtocol {

	public ServerProtocol1() {
	}

	public ServerProtocol1(Communicator c) {
		this.communicator = c;
	}

	@Override
	public void conversation() {

		try (Communicator communicator = getCommunicator();) {
			String response = communicator.readString();
			System.out.println("received " + response);

			communicator.writeString("Goodbye!");
			System.out.println("Sent Goodbye! ");

			TextMessage m = (TextMessage) communicator.readObject();
			System.out.println(m);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
