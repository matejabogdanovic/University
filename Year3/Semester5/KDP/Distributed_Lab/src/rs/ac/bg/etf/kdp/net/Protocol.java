package rs.ac.bg.etf.kdp.net;

import rs.ac.bg.etf.kdp.net.communicator.Communicator;

public interface Protocol {

	public void conversation();

	public void addCommunicator(Communicator communicator);

	public boolean removeCommunicator(Communicator communicator);

	public Communicator getCommunicator();
}
