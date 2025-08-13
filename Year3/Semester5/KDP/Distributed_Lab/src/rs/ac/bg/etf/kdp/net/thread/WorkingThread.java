package rs.ac.bg.etf.kdp.net.thread;

import java.net.Socket;

import rs.ac.bg.etf.kdp.net.Protocol;
import rs.ac.bg.etf.kdp.net.communicator.Communicator;
import rs.ac.bg.etf.kdp.net.communicator.ObjectSocketCommunicator;
import rs.ac.bg.etf.kdp.net.protocol.ProtocolFactory;

public class WorkingThread extends Thread {

	protected long id;
	protected String protocolName;
	protected Socket client;

	public WorkingThread(long id, Socket client, String protocol) {
		super("Working Thread " + id);
		this.id = id;
		this.client = client;
		this.protocolName = protocol;
	}

	@Override
	public void run() {
		work();
	}

	Protocol protocol;

	public void work() {
		try (Communicator communicator = getCommunicator();) {
			protocol = pf.createProtocol(protocolName);
			if (protocolName == null)
				return;
			communicator.init();
			protocol.addCommunicator(communicator);
			protocol.conversation();

		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public Socket getClient() {
		return client;
	}

	public Communicator getCommunicator() {
		return new ObjectSocketCommunicator(getClient());
	}

	static ProtocolFactory pf;
	private static Object protocolHandlerLock = new Object();

	static void setProtocolFactory(ProtocolFactory protocol) {
		synchronized (protocolHandlerLock) {
			if (pf != null) {
				throw new Error("factory already defined");
			}
			SecurityManager security = System.getSecurityManager();
			if (security != null) {
				security.checkSetFactory();
			}
			pf = protocol;
		}
	}

	static {
		setProtocolFactory(new ProtocolFactory());
	}
}
