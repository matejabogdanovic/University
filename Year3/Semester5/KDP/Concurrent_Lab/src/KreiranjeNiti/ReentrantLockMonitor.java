package KreiranjeNiti;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

public class ReentrantLockMonitor {
	private int num;
	private final ReentrantLock lock = new ReentrantLock(true);
	private Condition q = lock.newCondition();
	
	
	public ReentrantLockMonitor(int num) {
		this.num = num;
	}
	
	public void add(int n) {
		lock.lock();
		try {
			num += n;
			q.signal();
		}finally {
			lock.unlock();
		}
	}
	
	public int take(int n) {
		lock.lock();
		try {
			while(num == 0) { 
	
				q.awaitUninterruptibly();
				System.out.println("Budim se, num = " + num);
				
			}
			num -= n;
			return num;
			
		} 
		finally {
			lock.unlock();
		}
	}
	
	public void printNum() {
		System.out.println("Final num = " + num);
	}
}
