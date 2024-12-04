package Lab_2024_ChildCare;

import java.sql.Struct;
import java.util.Iterator;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.Semaphore;
import java.util.concurrent.atomic.AtomicInteger;

//Решити Child Care проблем користећи ConcurrentLinkedQueue и 
//друге произвољне синхронизационе директиве. 
//Родитељ доводи једно или више деце у обданиште и чека све док се не појави место, 
//како би оставио сву децу одједном и отишао. 
//Родитељ може и да одведе једно или више деце, такође одједном. 
//Мора се поштовати редослед доласка родитеља који остављају децу и васпитачица 
//које одлазе са посла. 
//Потребно је да програм буде максимално конкурентан и отпоран на прекиде.


public class Shared {
	static int R = 3;
	static int V = 2;
	static class roditeljRequest{
		Semaphore s;
		int cnt;
		public roditeljRequest(Semaphore s, int cnt) {
			this.s = s;
			this.cnt = cnt;
		}
	}
	static ConcurrentLinkedQueue<roditeljRequest> qr = new ConcurrentLinkedQueue();
	static ConcurrentLinkedQueue<Semaphore> qv = new ConcurrentLinkedQueue();
	static AtomicInteger qrcnt = new AtomicInteger(0), qvcnt = new AtomicInteger(0);
	static int vcnt = 0, ccnt = 0;
	static Semaphore mutex = new Semaphore(1,true); // bice fifo redosled
	
	
	public static void main(String[] args) {
		Roditelj[] roditelji = new Roditelj[R];
		Vaspitacica[] vaspitace = new Vaspitacica[V];
		System.out.println("Krecem================================");
		for (int i = 0; i < roditelji.length; i++) {
			roditelji[i] = new Roditelj(i+1+1);
			roditelji[i].start();
		}
		
		for (int i = 0; i < vaspitace.length; i++) {
			vaspitace[i] = new Vaspitacica();
			vaspitace[i].start();
		}
		
		try {
			Thread.sleep(50);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("Gasim================================");
		
		for (int i = 0; i < roditelji.length; i++) {
			roditelji[i].interrupt();
		}
		
		for (int i = 0; i < vaspitace.length; i++) {
			vaspitace[i].interrupt();
		}
		
		System.out.println("Kraj================================");
		
	}
}
