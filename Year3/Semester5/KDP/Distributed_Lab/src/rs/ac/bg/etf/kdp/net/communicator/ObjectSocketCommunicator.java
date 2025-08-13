package rs.ac.bg.etf.kdp.net.communicator;

import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.Arrays;

import rs.ac.bg.etf.kdp.net.Message;

public class ObjectSocketCommunicator implements Communicator {

	protected Socket client;
	protected ObjectOutputStream oout;
	protected ObjectInputStream oin;

	public ObjectSocketCommunicator() {
	}

	public ObjectSocketCommunicator(Socket client) {
		this.client = client;
	}

	public void init(Socket client) {
		this.client = client;
		init();
	}

	@Override
	public void init() {
		getObjectOutputstream();
		getObjectInputStream();
	}

	private boolean getObjectOutputstream() {
		try {
			OutputStream out = client.getOutputStream();
			oout = new ObjectOutputStream(out);
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	private boolean getObjectInputStream() {
		try {
			InputStream in = client.getInputStream();
			oin = new ObjectInputStream(in);
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	@Override
	public void close() {
		try {
			oin.close();
		} catch (IOException ex) {
		}
		try {
			oout.close();
		} catch (IOException ex) {
		}
		try {
			client.close();
		} catch (IOException ex) {
		}
	}

	@Override
	public Object readObject() throws CommunicationException {
		try {
			Object m = oin.readObject();
			return m;
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new CommunicationException();
		}
	}

	@Override
	public void writeObject(Object m) throws CommunicationException {
		try {
			oout.writeObject(m);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new CommunicationException();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public <T> Message<T> readMessage() throws CommunicationException {
		return (Message<T>) this.readObject();
	}

	@Override
	public <T> void writeMessage(Message<T> m) throws CommunicationException {
		this.writeObject(m);
	}

	@Override
	public String readString() throws CommunicationException {
		return (String) this.readObject();
	}

	@Override
	public void writeString(String s) throws CommunicationException {
		this.writeObject(s);
	}

	@Override
	public void flush() throws CommunicationException {
		try {
			oout.flush();
		} catch (Exception e) {
			e.printStackTrace();
			throw new CommunicationException();
		}
	}

	@Override
	public void reset() throws CommunicationException {
		try {
			oout.reset();
			oin.reset();
		} catch (Exception e) {
			e.printStackTrace();
			throw new CommunicationException();
		}
	}

	static final int BUFFSIZE = 1024;

	@Override
	public byte[] read() throws CommunicationException {
		byte[] b = new byte[BUFFSIZE];
		try {
			int num = oin.read(b);
			b = Arrays.copyOf(b, num);
		} catch (Exception e) {
			e.printStackTrace();
			throw new CommunicationException();
		}
		return b;
	}

	@Override
	public void write(byte[] data) throws CommunicationException {
		try {
			oout.write(data);
		} catch (Exception e) {
			e.printStackTrace();
			throw new CommunicationException();
		}
	}
}
