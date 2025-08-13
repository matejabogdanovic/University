package vezba;

import java.io.Serializable;

public class Request implements Serializable {

	private static final long serialVersionUID = 1L;
	public int id;
	public String operation; // eat, stop
	public Request(int id, String operation) {
		this.id = id;
		this.operation = operation;
	}
	
}
