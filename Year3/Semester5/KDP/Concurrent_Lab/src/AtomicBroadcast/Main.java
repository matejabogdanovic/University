package AtomicBroadcast;

import java.util.concurrent.atomic.AtomicInteger;

public class Main {
	static final int N = 22;
	static final int B = 5;
	static int[] buffer = new int[B];
	
	
	
	public static void main(String[] args) {
		Writer writer = new Writer();
		Reader[] reader = new Reader[N];
		
		writer.start();

		for(int i = 0; i < N; i++) {
			reader[i] = new Reader();
			reader[i].start();
		}
		
		for(int i = 0; i < N; i++) {
			try {
				reader[i].join(15);
			} catch (InterruptedException e) { e.printStackTrace(); }
		}
		
		try {
			writer.join(15);
		} catch (InterruptedException e) { e.printStackTrace(); }
		
		for(int i = 0; i < N; i++) {
			reader[i].interrupt();
		}
		writer.interrupt();
		
			
	}
}
