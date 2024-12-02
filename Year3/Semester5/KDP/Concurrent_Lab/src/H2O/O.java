package H2O;

import java.util.concurrent.BrokenBarrierException;

import javax.swing.plaf.basic.BasicInternalFrameTitlePane.IconifyAction;

public class O extends Molecule {

	public O(int id) {
		super(id);
	}
	@Override
	public void run() {
		try {
			
		
			while(true) {
				
//				while(Shared.H2Obarrier.getNumberWaiting() == 1) {// vec ima 1 kiseonik
//					Thread.yield();	
//				}	
				Shared.Obarrier.await(); // prolazi 1
				
				Shared.H2Obarrier.await();
				 
			}
		} catch (Exception e) {
			System.out.println("O" + id + " zavrsio.");
		}
	}
}
