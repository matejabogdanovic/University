package AtomicBroadcast;

import java.nio.Buffer;
import java.security.Identity;
import java.util.Iterator;
import java.util.concurrent.atomic.AtomicInteger;

import javax.sql.rowset.JoinRowSet;

public class Reader extends Thread{
	static AtomicInteger[] read = new AtomicInteger[Main.B];
	static{
		for(int i = 0; i<Main.B; i++) {
			read[i] = new AtomicInteger(0);
		}
	}
	 
	int myCursor = 0;
	int prevdata = -1;
	public Reader() {
		
	}
	
	@Override
	public void run() {
		while(!this.isInterrupted()) { // moze da se desi da obrne krug i da opet procita isto
			while(read[myCursor].get()==0 && !this.isInterrupted())
				Thread.yield();
			if(this.isInterrupted())
				break;
			
			int data = Main.buffer[myCursor]; // read
			if(data <= prevdata)
				System.out.println("AAAAAAAAAAAAAALOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
			System.out.println(this.getId() + " citam["+myCursor+"]= "+ data);
			
			read[myCursor].decrementAndGet(); // signal that i've read
			myCursor = (myCursor + 1)%Main.B;
			prevdata = data;
			
		}
		System.out.println(this.getId() + " citanje zavrsio");
	}
}
