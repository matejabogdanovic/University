package AtomicBroadcast;


import java.util.concurrent.atomic.AtomicInteger;

//Решити Atomic Broadcast проблем користећи AtomicInteger и опционо Semaphore . 
//Бафер садржи B елемената. 
//Постоји један произвођач и N потрошача који деле
//заједнички бафер капацитета B. Произвођач
//убацује производ у бафер на који чекају свих N
//потрошача, и то само у слободне слотове. Сваки
//потрошач мора да прими производ у тачно оном
//редоследу у коме су произведени, мада
//различити потрошачи могу у исто време да
//узимају различите производе.


public class Writer extends Thread{
	int wcursor = 0;


	
	public Writer() {
		
	}
	@Override
	public void run() {
		int i = 0;
		while(!this.isInterrupted()) {
			while(Reader.read[wcursor].get()!=0 && !this.isInterrupted())
				Thread.yield();
			if(this.isInterrupted())
				break;
			
			Main.buffer[wcursor] = i; // put in buffer
			
			System.out.println(this.getId() + " stavljam["+wcursor+"]= "+ i);
			
			Reader.read[wcursor].set(Main.N); // reset counter so readers can decrement when read this field
			wcursor = (wcursor + 1)%Main.B;
			//i = (i + 1)%Main.B;
			i++;
		
		}
		System.out.println(this.getId() + " pisanje zavrsio");
	}
}
	
	

