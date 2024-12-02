package H2O;

import java.util.concurrent.BrokenBarrierException;

public class H extends Molecule {

	public H(int id) {
		super(id);
	}
	@Override
	public void run() {
		try {
			while(true) {
				
//				while(Shared.H2Obarrier.getNumberWaiting() >= 2) {// vec ima 2 vodonika
//					Thread.yield();	
//				}	
				Shared.Hbarrier.await(); // prolaze u paru
				
				Shared.H2Obarrier.await();
				
			}
		} catch (Exception e) {
			System.out.println("H" + id + " zavrsio.");
		}
	}
}
