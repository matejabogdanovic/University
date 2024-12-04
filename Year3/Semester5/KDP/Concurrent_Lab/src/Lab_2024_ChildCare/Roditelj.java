package Lab_2024_ChildCare;

import java.util.concurrent.Semaphore;

public class Roditelj extends Thread {
	int cnt;
	
	public Roditelj(int cnt) {
		this.cnt = cnt;
	}
 
	private void dovedi() throws InterruptedException {
		
		Shared.mutex.acquire();
		System.out.println(currentThread().getId() + " dovodim " + cnt);
		if(Shared.vcnt * 3 < Shared.ccnt + this.cnt || Shared.qrcnt.get() > 0) { 
			System.out.println(currentThread().getId() + " nema mesta " + cnt);
			
			Shared.qrcnt.incrementAndGet();
			Semaphore mySemaphore = new Semaphore(0);
			Shared.qr.add(new Shared.roditeljRequest(mySemaphore, this.cnt));
			Shared.mutex.release();
			mySemaphore.acquire();
		
		}
		Shared.ccnt += this.cnt; // doveo decu
		System.out.println(currentThread().getId() + " doveo " + cnt);
		
		if(Shared.qvcnt.get()>0 && 
		  (Shared.vcnt -1) * 3 >= Shared.ccnt) {// probaj da vasp ode ako ne, roditelje

			Shared.qvcnt.decrementAndGet(); // vwaiting --
			Shared.qv.remove().release(); // signal vasp 
			
		}else if(Shared.qrcnt.get()>0 && 
				Shared.qr.peek().cnt + Shared.ccnt <= Shared.vcnt*3) {
			
			Shared.qrcnt.decrementAndGet(); // rwaiting --
			Shared.qr.remove().s.release(); // signal parent 
			
		}else 
			Shared.mutex.release();
		
	

	}
	
	 
	private void odvedi() throws InterruptedException {
		Shared.mutex.acquire();
		System.out.println(currentThread().getId() + " uzimam decu " + cnt);
		
		Shared.ccnt -= this.cnt;
		System.out.println(currentThread().getId() + " uzeo decu " + cnt);
		if(Shared.qvcnt.get()>0 && 
				  (Shared.vcnt -1) * 3 >= Shared.ccnt) {// probaj da vasp ode ako ne, roditelje

			Shared.qvcnt.decrementAndGet(); // vwaiting --
			Shared.qv.remove().release(); // signal vasp 
					
		}else if(Shared.qrcnt.get()>0&& 
				Shared.qr.peek().cnt + Shared.ccnt <= Shared.vcnt*3) {
					
			Shared.qrcnt.decrementAndGet(); // rwaiting --
			Shared.qr.remove().s.release(); // signal parent 
					
		}else 
			Shared.mutex.release();
		
	}
	
	@Override
	public void run() {
		try {
			while (true) {
				
				Thread.sleep((int)Math.random()*1000);
				
				dovedi();
			
				
				Thread.sleep((int)Math.random()*1000);
				
				odvedi();

				
				
				
			}
		} 
		catch (InterruptedException e) {
			System.out.println("Roditelj zavrsava");
		}

	}
}
