package Shared;



public class Musterija extends Thread {
	
	private void udji() throws InterruptedException {
		System.out.println("Musterija: " + currentThread().getId() + " dolazim.");
		Shared.stolice.put(currentThread().getId());
		
		synchronized (Shared.shop) {

			while(Shared.shop.next != currentThread().getId()) {
				Shared.shop.wait();
			} // brica ce me probuditi 
			System.out.println("Musterija: " + currentThread().getId() + " moj red.");
			
		}
		System.out.println("Musterija: " + currentThread().getId() + " zauzimam stolicu.");
		// zauzimam stolicu
		synchronized(Shared.stolica) {
			Shared.stolica.zauzeo = currentThread().getId();
			Shared.stolica.notify();
			while(Shared.stolica.zauzeo == currentThread().getId()) {// sisanje
				Shared.stolica.wait(); 
			}
			System.out.println("Musterija: " + currentThread().getId() + " gotovo sisanje.");
		}
		
	}
	private void plati() {
		synchronized (Shared.stolica) {
			System.out.println("Musterija: " + currentThread().getId() + " evo para.");
			Shared.stolica.novac = Shared.cena;
			Shared.stolica.notify(); // reci mu da je gotov i da plati

		}
		
	}
	@Override
	public void run() {
		try {
			
		
			while(!this.isInterrupted()) {
				Thread.sleep((int)Math.random()*1000+100);
				udji();

				plati();
			}
		} catch (InterruptedException e) {
			// TODO: handle exception
		}finally {
			System.out.println("Musterija: " + currentThread().getId() + " zavrsila.");
		}
	
	}


}
