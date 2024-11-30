package KreiranjeNiti;

public class SynMonitor {
	private int num;
	
	public SynMonitor(int num) {
		this.num = num;
	}
	
	public synchronized void add(int n) {
		num += n;
		notify(); 
	}
	
	public synchronized void take(int n) {
		
		while(num == 0) { // if => num can be negative but we don't want that
			try {
				this.wait();
				System.out.println("Budim se, num = " + num);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}System.out.println(num);
		num -= n;
	}
	
	public void printNum() {
		System.out.println("Final num = " + num);
	}
		
	
}
