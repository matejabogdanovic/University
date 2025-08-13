package vezba;
public class Philosopher extends Thread{

	private int id;
	private Service service;
	public Philosopher( int id, Service service) {
	
		this.id = id;
		this.service = service;
	}
	
	@Override
	public void run() {
		for (int i = 0; i < 5; i++) {
			try {
				Thread.sleep((long) (Math.random()*1000));
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			this.service.eat(id);
		}
	}

	
	public static void main(String[] args) {
		Service service = new Service(args[0], Integer.parseInt(args[1]));
		for(int i = 0; i < 5; i++) {
			new Philosopher(i,service).start();
		}
		
	}
}
