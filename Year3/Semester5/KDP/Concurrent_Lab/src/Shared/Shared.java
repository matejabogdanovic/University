package Shared;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ConcurrentLinkedQueue;

//Користећи regione i ArrayBlockingQueue дисциплином решити
//проблем берберина који спава (The Sleeping Barber Problem).
//Берберница се састоји од чекаонице са n=5 столица и берберске
//столице на којој се људи брију. Уколико нема муштерија, брица спава.
//Уколико муштерија уђе у берберницу и све столице су заузете,
//муштерија CEKA DA SEDNE. Уколико је берберин зaузет, а има
//слободних столица, муштерија седа и чека да дође на ред. Уколико
//берберин спава, муштерија (dolazak musterije) га буди. Обезбедити да се муштерије
//опслужују по редоследу долазака.

public class Shared {
	static final int n = 5;
	static final int M = 6;
	// neblokirajuce -> add i poll
	// blokirajuce -> put i take
	static class Shop{
		static volatile long next = -1;
		
	}
	static class Stolica{
		static volatile int novac = -1;
		static volatile long zauzeo = -1;
	}
	static int cena = 1;
	static Stolica stolica = new Stolica();
	static Shop shop = new Shop();
	static ArrayBlockingQueue<Long> stolice = new ArrayBlockingQueue<Long>(n, true);
	
	public static void main(String[] args) throws InterruptedException {
		Musterija[] musterije = new Musterija[M];
		Brica brica = new Brica();
		
		System.out.println("Pocetak====================");
		for (int i = 0; i < musterije.length; i++) {
			musterije[i] = new Musterija();
			musterije[i].start();
		}
		
		brica.start();
		
		Thread.sleep(1000);
		
		System.out.println("Gasim====================");
		for (int i = 0; i < musterije.length; i++) {
			musterije[i].interrupt();
		}
		brica.interrupt();
		System.out.println("Kraj====================");
	}
	
}
