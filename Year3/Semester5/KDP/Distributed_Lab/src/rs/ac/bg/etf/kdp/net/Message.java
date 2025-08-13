package rs.ac.bg.etf.kdp.net;

import java.io.Serializable;

public interface Message<T> extends Serializable {

	public void setBody(T body);

	public T getBody();

	public void setId(long id);

	public long getId();
}
