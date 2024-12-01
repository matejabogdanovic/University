package KreiranjeNiti;



public class Nit extends Thread{
	ReentrantLockMonitor banka;
	int id;
	int num = -69;
	public Nit(ReentrantLockMonitor banka, int id) {
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
		
		if (id%2==0) {
			this.interrupt();
			num=banka.take(1);
			System.out.println("Id="+id+" num=" + num);
		}
		else 
			banka.add(1);
		
	}
}
