package KreiranjeNiti;

public class Nit extends Thread{

	public Nit() {
		this.start();
	}
	
	@Override
	public void run() {
		System.out.println("RADIM POSO NE DIRAJ");
	}
}
