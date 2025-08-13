package rs.ac.bg.etf.kdp.net;

public interface Buffer<T> {

	public static final int MAXBUFFERSIZE = 150;

	public T get();

	public void put(T data);

	public void remove(T data);

	public int size();

	public int capacity();
}
