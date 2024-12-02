package DinningPhil;

//import java.util.concurrent.atomic.AtomicInteger;

public class Phil extends Thread{
	int id, myTicket = 0;
	
	//static AtomicInteger ticket = new AtomicInteger(-1);
	//static AtomicInteger next = new AtomicInteger(-1);
	public Phil(int id) {
		this.id = id;
	}
	@Override
	public void run() {
		try {
			while(!this.isInterrupted()) {
				// think()
			
				
				Thread.sleep((int)(Math.random() * 1000));
				 
				synchronized (Shared.forks) {
					myTicket = Shared.forks.ticket++;
					
					while(Shared.forks.next != myTicket ||
							Shared.forks.status[(id+1)%Shared.N] == 1 ||
							Shared.forks.status[(id-1 + Shared.N)%Shared.N] == 1
							) {
						
						Shared.forks.wait();
						 
					}
					Shared.forks.status[id] = 1; // eating
					Shared.forks.next++;
					
					if(Shared.forks.status[(id+1)%Shared.N] == 1 ||
					   Shared.forks.status[(id-1 + Shared.N)%Shared.N] == 1)
						System.err.println("NEMOGUCE BRATE");
					System.out.println("==============Ja: " + id + " ticket: " + myTicket + " jedem");
					
					Shared.forks.notifyAll();
					
				}
				
				
				Thread.sleep((int)(Math.random() * 1000 + 100));
				 
				synchronized (Shared.forks) {
					
					System.out.println("Ja: " + id + " ticket: " + myTicket + " zavrsio");
					Shared.forks.status[id] = 0; // eating
					Shared.forks.notifyAll();
				}
				
			}
			
		} 
		catch (InterruptedException e) {
			System.out.println("Zavrsavam " + id);
		}

	}
	
}
