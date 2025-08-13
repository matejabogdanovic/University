package rs.ac.bg.etf.kdp.net.communicator;

public class CommunicationException extends Exception {

	private static final long serialVersionUID = 1L;

	public CommunicationException() {
		super();
	}

	public CommunicationException(String error) {
		super(error);
	}
}
