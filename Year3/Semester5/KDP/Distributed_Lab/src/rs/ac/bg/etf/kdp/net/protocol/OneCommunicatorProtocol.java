package rs.ac.bg.etf.kdp.net.protocol;

import rs.ac.bg.etf.kdp.net.Protocol;
import rs.ac.bg.etf.kdp.net.communicator.Communicator;

public abstract class OneCommunicatorProtocol implements Protocol {

	Communicator communicator;

	public OneCommunicatorProtocol() {
	}

	public OneCommunicatorProtocol(Communicator c) {
		this.communicator = c;
	}

	@Override
	public void addCommunicator(Communicator c) {
		this.communicator = c;
	}

	@Override
	public boolean removeCommunicator(Communicator c) {
		if (this.communicator.equals(c)) {
			c = null;
			return true;
		}
		return false;
	}

	@Override
	public Communicator getCommunicator() {
		return communicator;
	}

	@Override
	public abstract void conversation();

}
