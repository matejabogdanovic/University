package HilzersBarbershop;

import java.util.concurrent.Semaphore;

public class Barber extends Thread{
	int id;
	long novac = 0;
	Semaphore mySem = new Semaphore(0);
	public Barber(int id) {
		this.id = id;
	}
	
	private void sledeci() throws InterruptedException {
		Shared.barberi.add(this);
		if(Shared.initilized < 3) {
			synchronized (this) {
				this.notify();
			}
		}

		
		Shared.mutex.acquire();
		System.out.println(Shared.stajanje + " stoje.");
		System.out.println(Shared.stolice + " stolice.");
		System.out.println("Barber " + id + " cekam budjenje.");
		Shared.mutex.release();
		mySem.acquire(); // cekaj da te neko probudi
		System.out.println("Barber " + id + " probudio se. Krece sisanje.");
		
	}
	private void naplati() throws InterruptedException {
		Shared.mutex.acquire();
		Semaphore klijent = Shared.barberStolice[id];
		Shared.barberStolice[id] = mySem;
		klijent.release();
		System.out.println("Barber " + id + " cekam placanje.");
		mySem.acquire(); // cekaj da plati, ne pustaj mutex
		System.out.println("Barber " + id + " placeno.");
		
	}
	@Override
	public void run() {
		try {
			while(!this.isInterrupted()) {
				System.out.println("Barber " + id + " sledeci.");
				sledeci();
				Thread.sleep((int)Math.random()*100); // sisanje
				naplati();
			}
		} catch (InterruptedException e) {
			// TODO: handle exception
		}finally {
			System.out.println("Brica " + id + " zavrsio, zarada: " + novac);
		}
	
	}
}
