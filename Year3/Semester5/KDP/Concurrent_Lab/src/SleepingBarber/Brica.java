package SleepingBarber;

public class Brica extends Thread {
	private long zarada = 0;
	private long musterijaId = -1;
	private void sledeci() throws InterruptedException {
		System.out.println("Brica, uzimam sledeceg.");
		musterijaId =  Shared.stolice.take(); // spava odnosno ceka da dodje musterija
		synchronized (Shared.shop) {
			System.out.println("Brica," + " uzimam " + musterijaId+ ". Ostali da cekaju: " + Shared.stolice);
			Shared.shop.next = musterijaId;
			Shared.shop.notifyAll();
		}
		
		synchronized (Shared.stolica) {
			System.out.println("Brica, sedi: " + musterijaId);
			while (Shared.stolica.zauzeo == -1) {
				Shared.stolica.wait(); // cekam da sedne
			}
			System.out.println("Brica, seo si krece sisanje: " + musterijaId);
			// seo, krece sisanje
		}
	}
	
	private void naplati() throws InterruptedException {
		synchronized (Shared.stolica) {
			System.out.println("Brica, gotovo sisanje: " + musterijaId);
			Shared.stolica.zauzeo = -1;
			Shared.stolica.notify(); // reci mu da je gotov i da plati
			while (Shared.stolica.novac == -1) {
				Shared.stolica.wait();
			}
			zarada += Shared.stolica.novac;
			Shared.stolica.novac = -1;
			System.out.println("Brica, uzeo pare: " + musterijaId + " zarada je: " + zarada);
		}
	}
	
	@Override
	public void run() {
		try {	
		
			while(!this.isInterrupted()) {
				sledeci();
				Thread.sleep((int)Math.random()*1000+100); // sisanje traje
				naplati();
				Thread.sleep((int)Math.random()*1000+100); 
			}
		} catch (InterruptedException e) {
			// TODO: handle exception
		}finally {
			System.out.println("Brica: " + currentThread().getId() + " zavrsio.");
		}
	
	}
}
