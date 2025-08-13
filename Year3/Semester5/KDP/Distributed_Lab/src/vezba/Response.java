package vezba;

import java.io.Serializable;

public class Response implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public long time;
	public Response(long time) {
		super();
		this.time = time;
	}
}
