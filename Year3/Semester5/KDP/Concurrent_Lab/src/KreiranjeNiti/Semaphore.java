package KreiranjeNiti;

public class Semaphore {
	private int s = 0;
	Semaphore(int s){
		this.s = s;
	}
	
	public synchronized void swait() {
		while(s==0) {
			try {wait();}
			catch (InterruptedException e) {e.printStackTrace();}
		} 
		s--;
	}
	
	public synchronized void ssignal() {
		s++;
		notify(); // budi jednog sa waita
	}
}
