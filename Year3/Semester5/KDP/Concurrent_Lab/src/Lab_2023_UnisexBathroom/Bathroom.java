package Lab_2023_UnisexBathroom;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

public class Bathroom {
	ReentrantLock lock = new ReentrantLock(true);
	Condition qm = lock.newCondition();
	Condition qw = lock.newCondition();
	volatile int m_waiting = 0;
	volatile int w_waiting = 0;
	volatile int w_pissing = 0;
	volatile int m_pissing = 0;
	volatile int turn = -1;
	void enterM() {
		lock.lock();
		try {
			m_waiting++;
			while(w_pissing > 0 || turn == 1) {
				System.out.println("Zena ima: " + w_waiting);
				qm.await();
			}
			turn = 0;
			m_waiting--;
			m_pissing++;
			
		}catch (Exception e) {
		
		} 
		finally {
			lock.unlock();
		}
		
		
	}
	

	void enterW() {
		lock.lock();
		try {
			w_waiting++;
			while(m_pissing > 0 || turn == 0 ) {
				System.out.println("Muskih ima: " + w_waiting);
				qw.await();
			}
			turn = 1;
			w_waiting--;
			w_pissing++;
		
		}catch (Exception e) {
		
		} 
		finally {
			lock.unlock();
		}
		
		
	}
	
	void exitM() {
		lock.lock();
		try {
			m_pissing--;
			if(w_waiting > 0)
				turn = 1;
			
			if (m_pissing == 0) {
				if(w_waiting > 0) {turn = 1; qw.signal(); }
				else if(m_waiting > 0)qm.signal();
				else turn = -1;
			}else if(w_waiting == 0 && m_waiting > 0)
				qm.signal();
			
		}catch (Exception e) {
			
		} 
		finally {
			
			lock.unlock();
		}
		
	}
	
	void exitW() {
		lock.lock();
		try {
			w_pissing--;
			if(m_waiting > 0)
				turn = 0;
			
			if (w_pissing == 0) {
				if(m_waiting > 0) {turn = 0; qm.signal(); }
				else if(w_waiting > 0)qw.signal();
				else turn = -1;
			}else if(m_waiting == 0 && w_waiting > 0)
				qw.signal();

		}catch (Exception e) {
			
		} 
		finally {
			
			lock.unlock();
		}
		
	}

}
