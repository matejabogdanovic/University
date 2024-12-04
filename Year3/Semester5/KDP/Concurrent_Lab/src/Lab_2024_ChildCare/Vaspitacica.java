package Lab_2024_ChildCare;

import java.util.concurrent.Semaphore;

public class Vaspitacica extends Thread{
	
	void dodji() throws InterruptedException {
		Shared.mutex.acquire();
		System.out.println("Vaspitacica "+currentThread().getId() + " dolazim.");
		Shared.vcnt++;
		
		if(Shared.qrcnt.get()>0&& 
				Shared.qr.peek().cnt + Shared.ccnt <= Shared.vcnt*3) {
			
			Shared.qrcnt.decrementAndGet(); // rwaiting --
			Shared.qr.remove().s.release(); // signal parent 
					
		}else if(Shared.qvcnt.get()>0) { // pusti vaspitacicu da ode
			
			Shared.qvcnt.decrementAndGet(); // vwaiting --
			Shared.qv.remove().release(); // signal vasp 
			
		}else {
			Shared.mutex.release();
		}
		
	}
	
	void odi() throws InterruptedException {
		Shared.mutex.acquire();
		System.out.println("Vaspitacica "+currentThread().getId() + " hocu idem.");
		if( (Shared.vcnt -1) * 3 < Shared.ccnt) {
			System.out.println(currentThread().getId() + " ne mogu da idem=> ccnt=" + Shared.ccnt + " vcnt*3=" + Shared.vcnt*3);
			Shared.qvcnt.incrementAndGet();
			Semaphore mySemaphore = new Semaphore(0);
			Shared.qv.add(mySemaphore);
			Shared.mutex.release();
			mySemaphore.acquire();
		}
		
		Shared.vcnt --; // otisla
		System.out.println("Vaspitacica "+currentThread().getId() + " ja otisla.");
		
		if(Shared.qrcnt.get()>0 && 
			Shared.qr.peek().cnt + Shared.ccnt <= Shared.vcnt*3) {
					
			Shared.qrcnt.decrementAndGet(); // rwaiting --
			Shared.qr.remove().s.release(); // signal parent 
					
		}else if(Shared.qvcnt.get()>0 && 
				 (Shared.vcnt -1) * 3 >= Shared.ccnt) {// probaj da vasp ode ako ne, roditelje

			Shared.qvcnt.decrementAndGet(); // vwaiting --
			Shared.qv.remove().release(); // signal vasp 
							
		}
		else 
			Shared.mutex.release();
	}
	@Override
	public void run() {
		try {
			while (true) {
				
				//Thread.sleep((int)Math.random()*1000);

				dodji();
					
				//Thread.sleep((int)Math.random()*1000);
				

				odi();
				
				
				
				
			}
		} 
		catch (InterruptedException e) {
			System.out.println("Vaspitacica zavrsava");
		}

	}
}
