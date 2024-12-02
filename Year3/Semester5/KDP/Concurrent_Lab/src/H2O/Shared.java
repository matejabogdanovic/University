package H2O;
//Постоје два типа атома, водоник и кисеоник, који
//долазе до баријере. Да би се формирао молекул
//воде потребно је да се на баријери у истом
//тренутку нађу два атома водоника и један атом
//кисеоника. Уколико атом кисеоника дође до
//баријере на којој не чекају два атома водоника,
//онда он чека да се они сакупе. Уколико атом
//водоника дође до баријере на којој се не налазе
//један кисеоник и један водоник, он чека на њих.
//Баријеру треба да напусте два атома водоника и
//један атом кисеоника.

import java.util.Iterator;
import java.util.concurrent.CyclicBarrier;

public class Shared{
	static final int N = 6;
	static CyclicBarrier Hbarrier = new CyclicBarrier(2, new Runnable() {
		@Override
		public void run() {
			System.out.println("Dosli 2 vodonika");
		}
	});
	static CyclicBarrier Obarrier = new CyclicBarrier(1, new Runnable() {
		@Override
		public void run() {
			System.out.println("Dosao kiseonik");
		}
	});
	
	static CyclicBarrier H2Obarrier = new CyclicBarrier(3, new Runnable() {
		// radi se atomicno, poslednja nit koja je usla a da barijera sme da se pusti
		// izvrsava ovo pre pustanja barijere
		@Override
		public void run() {
			Thread thread = Thread.currentThread();
			if(thread instanceof H) { 
				H h = (H)thread;
				System.out.println("BOND H1="+h.id);
			}
			else {
				O o = (O)thread;
				System.out.println("BOND O="+o.id);
			}
			while(true) {
				Thread.yield();
			}
		}
	});
	public static void main(String[] args) {
		Molecule[] molekuli = new Molecule[2*N];
		for(int i=0; i<N; i++) {
			molekuli[i] = new H(i);
			molekuli[i].start();
		}
		for(int i=0; i<N; i++){
			molekuli[i+N] = new O(i);
			molekuli[i+N].start();
		}
		
		try {
			Thread.sleep(5000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("ZAVRSAVAJTE!=====================================");
		for(int i=0; i<2*N; i++){
			molekuli[i].interrupt();
			
		}
	}
}
