package HilzersBarbershop;

import java.util.concurrent.Semaphore;

public class Musterija extends Thread{
	private Semaphore mySem = new Semaphore(0);
	private Barber myBarber;
	private boolean probudjen = false;
	private boolean udji() throws InterruptedException {
		// probaj da udjes da sednes
		if(Shared.stoliceSem.tryAcquire()) {
			// mozes da sednes
			Shared.stolice.addLast(mySem);
			probudjen = false;
			if(Shared.stolice.peekFirst() != mySem) {
				// morace da se blokira
				System.out.println(currentThread().getId() + " cekam sisanje odmah.");
				cekaj_na_sisanje();
				probudjen = true;
			} 
	
		}else if(Shared.stajanjeSem.tryAcquire()) {
			// nisi mogao da sednes al mozes da stanes
			
			System.out.println(currentThread().getId() + " cekam da sednem.");
			cekaj_da_sednes();

			System.out.println(currentThread().getId() + " sad cu da sednem.");
			// ovim se postuje fifo redosled
			// znam da nije bukvalno musterija zauzela njegovo mesto al smatracemo
			// da kad je musterija koja je najduze sedela, ustala, onda su se svi
			// pomerili za jedno mesto tako da se fifo redosled odrzi, a onda
			// musterija koja je najduze stajala, ide da sedne na poslednje mesto

			cekaj_na_sisanje();
			probudjen = true;
		}
		else return false;
		
		return true;
		
	}
	
	private void cekaj_da_sednes() throws InterruptedException {
		Shared.stajanje.addLast(mySem);
		
		mySem.acquire(); // stoji, cekaj da sednes
		// neko me budio i predao stafetnu palicu za sedenje
		// nakon ovog se poziva cekaj na sisanje=>
		
		Shared.stajanjeSem.release(); // pusti nekog drugog da moze da stane
	}

	private void cekaj_na_sisanje() throws InterruptedException {

		System.out.println(currentThread().getId() + " seo.");
		mySem.acquire(); // cekaj na sisanje
		// neko me budio, idem da se sisam, pusticu da neko sedne
		System.out.println(currentThread().getId() + " sad cu da pustim stolicu.");
		if(Shared.stajanje.peekFirst()!=null) {
			Semaphore s	= Shared.stajanje.removeFirst(); // pusti ga da sedne
			Shared.stolice.addLast(s);	// uradi posao umesto njega, pusti ga da sedne
			s.release();
			
			System.out.println(currentThread().getId() + " stavio sam sledeceg da sedne.");
		}else 
			Shared.stoliceSem.release(); // u suprotnom samo pusti stolicu
			
		System.out.println(currentThread().getId() + " idem da se sisam.");
		
		
	}
	private void sisanje() throws InterruptedException {
		if(!probudjen)
			Shared.mutex.acquire(); 
		// da li je probudjen ili je odmah dosao na red
		myBarber = Shared.barberi.pollFirst();
		
		if(myBarber == null) {
			// nema slobodnog barbera blokiraj se
			Shared.mutex.release();
			cekaj_na_sisanje();
			probudjen = true;
			myBarber  = Shared.barberi.pollFirst();
		}else if(Shared.stolice.peekFirst() == mySem) {
			Shared.stolice.removeFirst(); // izbaci sebe ako te niko nije budio
		}
		
		System.out.println( "barberi " + Shared.barberi + " myid " + currentThread().getId());
		
		System.out.println(currentThread().getId() +  " budim barbera.");	
		System.out.println(currentThread().getId() +  " cekam barbera " + myBarber.id + "  za stolicu.");
		Shared.barberStolice[myBarber.id] = mySem;
		myBarber.mySem.release();
		Shared.mutex.release();
			
		mySem.acquire(); // cekaj da te osisa
		// osisan sam
		myBarber.novac += 1; // daj mu novac	
		System.out.println(currentThread().getId() + " dao novac barberu " + myBarber.id + " ima sad " + myBarber.novac);
		Shared.barberStolice[myBarber.id].release(); // reci barberu da si mu dao novac
		
		probudjen=false;
		myBarber = null;
		if(Shared.stolice.peek() != null) {
			System.out.println(getId() + " pustam sledeceg.");
			Shared.stolice.removeFirst().release(); // pusti sledeceg
		}
		else Shared.mutex.release();
	}
	@Override
	public void run() {
		try {
			for (int i = 0; i < 1000; i++) {

				while(udji()==false) { // cekaj da udjes da se sisas
					Thread.sleep((int)Math.random()*100);
				}
					// mozes dosao si na red da se sisas
				sisanje();
			}
			
		} catch (InterruptedException e) {
			// TODO: handle exception
		}finally {
			System.out.println("Musterija " + currentThread().getId() + " zavrsila.");
		}
	
	}
}
