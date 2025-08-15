package Honey;

import java.io.PrintWriter;
import java.net.NoRouteToHostException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Iterator;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;

//Постоји N пчела и један гладан медвед. Они користе
//заједничку кошницу. Кошница је иницијално
//празна, а може да прими H напрстака меда.
//Медвед спава док се кошница не напуни медом,
//када се напуни медом, он поједе сав мед након
//чега се враћа на спавање. Пчелице непрестано
//лете од цвета до цвета и сакупљају мед. Када
//прикупе један напрстак долазе и стављају га у
//кошницу. Она пчела која је попунила кошницу
//буди медведа.

public class Hive {
	int port;
	int capacity;
	int n = 0;
	ExecutorService pool;

	Thread bearThread;
	Object lockBear = new Object();
	public Hive(int port, int capacity) {
		this.port = port;
		this.capacity = capacity;
		this.pool = Executors.newFixedThreadPool(30);
		
		
	}
	
	synchronized void put() throws InterruptedException {
		System.out.println("Trying to put.");
		while(n == capacity) {
			System.out.println("Having to wait.");
			this.wait();
		}
		n++;
		System.out.println("Did put.");
		if(n == capacity) {
			System.out.println("Waking up bear!");
			synchronized (lockBear) {
				
				lockBear.notify();
			}
		}
		this.notifyAll();
	}
	
	 void eat(PrintWriter writer) throws InterruptedException {
		synchronized(lockBear) {
			while(n!=capacity) {
				System.out.println("Bear has to wait/sleeping.");
				
				lockBear.wait();
				
			}
	
			System.out.println("Getting: " + n);
			n = 0;
			writer.println("Ok");
		}
		synchronized (this) {
			this.notifyAll();
		}
		
		
	}
	

	void shutdownAndAwaitTermination(ExecutorService pool) {
		   pool.shutdown(); // Disable new tasks from being submitted
		   
		   try {
		     // Wait a while for existing tasks to terminate
		     if (!pool.awaitTermination(60, TimeUnit.SECONDS)) {
		       pool.shutdownNow(); // Cancel currently executing tasks
		       // Wait a while for tasks to respond to being cancelled
		       if (!pool.awaitTermination(60, TimeUnit.SECONDS))
		           System.err.println("Pool did not terminate");
		     }
		   } catch (InterruptedException ex) {
		     // (Re-)Cancel if current thread also interrupted
		     pool.shutdownNow();
		     // Preserve interrupt status
		     Thread.currentThread().interrupt();
		   }
	}
	
	public void start() {
		try (ServerSocket serverSocket = new ServerSocket(port)) {
			int i = 0;
			while(i < 55) {
				Socket  clientSocket = serverSocket.accept();
				System.out.println("Hive: accepted request.");
				pool.submit(new HiveThread(this, clientSocket));
				
				i++;
			}
			System.out.println("Shutting down.");
			shutdownAndAwaitTermination(pool);
		} catch (Exception e) {
			System.err.println(e);
		}
	}


	public static void main(String[] args) {
		new Hive(Integer.parseInt(args[0]),Integer.parseInt(args[1])).start();
		
	}
}
