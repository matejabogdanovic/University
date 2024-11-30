package KreiranjeNiti;

public class Nit extends Thread{
	SynMonitor banka;
	int id;
	public Nit(SynMonitor banka, int id) {
		this.banka = banka;
		this.id = id;
		this.start();
	}
	
	@Override
	public void run() {
		
		try {
			sleep(100);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		if (id%2==0) 
			banka.take(1);
		else 
			banka.add(1);
	}
}
