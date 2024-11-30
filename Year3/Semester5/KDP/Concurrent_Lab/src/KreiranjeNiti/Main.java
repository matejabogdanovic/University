package KreiranjeNiti;

import java.util.concurrent.Semaphore;

import javax.swing.plaf.multi.MultiTextUI;

public class Main {

	

	public static void main(String[] args) {
		Thread[] threads = new Thread[10];
		for (int i = 0; i < 10; i++) {
			threads[i] = new Thread(new Runnable() {
				static int var = 0;
				static Semaphore mutex = new Semaphore(1);
				@Override
				public void run() {
				
					mutex.acquireUninterruptibly();
					++var;
					System.out.println(" var = " + var);
					mutex.release();
					
				}
			});
			threads[i].start();
		}
		
		for (int i = 0; i < 10; i++) {
			try {
				threads[i].join();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		
		System.out.println("Mejn end");
	}
	
}
