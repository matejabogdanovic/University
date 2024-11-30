package KreiranjeNiti;


public class Main{

	public static void main(String[] args) {
		Thread[] threads = new Thread[100];
		SynMonitor banka  = new SynMonitor(0);
		for (int i = 0; i < 100; i++) 
			threads[i] = new Nit(banka, i);
		
		
		for (int i = 0; i < 100; i++) {
			try {
				threads[i].join();
			} catch (InterruptedException e) {
				
				e.printStackTrace();
			}
			
		}
		
		banka.printNum();
	}
	
}
