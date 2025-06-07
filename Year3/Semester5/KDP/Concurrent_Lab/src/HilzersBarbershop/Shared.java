package HilzersBarbershop;
//Посматра се берберница у којој за три различите столице
//раде три берберина (The Hilzer's Barbershop problem). Поред ове три
//столице у берберници се налази и чекаоница која прима 10
//муштерија које могу да седе и 10 које могу да стоје, укупно 20. Када
//муштерија дође до бербернице уколико на шишање чека више од 20
//муштерија онда одлази, а уколико берберница није пуна онда остаје.
//Уколико барем један берберин спава муштерија која дође на ред за
//шишање буди оног берберина који је најдуже спавао и седа у његову
//столицу. На место те муштерије која је устала седа муштерија која је
//најдуже стајала. Уколико су сви бербери заузети онда муштерија
//чека, и то ако има места за седење седа, а ако не онда стоји.
//Муштерије се опслужују у редоследу по коме су приспеле, и седају у
//истом том редоследу. Када берберин заврши са шишањем муштерија
//му плаћа и излази из бербернице. Берберин све време или спава или
//шиша или наплаћује. Решити овај проблем користећи расподељене
//Semaphore i ConcurrentLinkedDeque

import java.util.concurrent.ConcurrentLinkedDeque;
import java.util.concurrent.Semaphore;


public class Shared {
	static final int n = 10; // broj mesta
	static final int M = 25; // broj musterija
	static final int B = 3; // broj barbera
	
	static ConcurrentLinkedDeque<Semaphore> stolice = new ConcurrentLinkedDeque<Semaphore>();
	static ConcurrentLinkedDeque<Semaphore> stajanje = new ConcurrentLinkedDeque<Semaphore>();
	static Semaphore shop = new Semaphore(n*2, true);
	static Semaphore mutex = new Semaphore(1, true);
	static Semaphore stoliceSem = new Semaphore(n,true);
	static Semaphore stajanjeSem = new Semaphore(n,true);
	static volatile int initilized =0;
	static ConcurrentLinkedDeque<Barber> barberi = new ConcurrentLinkedDeque<Barber>();
	static Semaphore[] barberStolice = new Semaphore[B];
	public static void main(String[] args) throws InterruptedException {
		for (int i = 0; i < barberStolice.length; i++) {
			barberStolice[i] = null;
		}
		Musterija[] musterije = new Musterija[M];
		Barber[] brice = new Barber[B];
		
		System.out.println("Pocetak====================");
		
		for (int i = 0; i < brice.length; i++) {
			brice[i] = new Barber(i);
			brice[i].start();
			synchronized (brice[i]) {
				brice[i].wait(); // cekaj da se inicijalizuju
				initilized++;
			}
		}
		
		
		for (int i = 0; i < musterije.length; i++) {
			musterije[i] = new Musterija();
			musterije[i].start();
		}

		for (int i = 0; i < musterije.length; i++) {
			musterije[i].join();
		}// cekaj musterije da zavrse
		
		System.out.println("Gasim====================");

		// gasi brice
		for (int i = 0; i < brice.length; i++) {
			brice[i].interrupt();
		}
		System.out.println("Kraj====================");
	}
}
