package vezba;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.ProcessBuilder.Redirect;
import java.lang.annotation.Retention;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
//1. Решити DiningPhilosopher проблем користећи ExecutorService и 
//где је потребно да сервер враћа филозоферу информацију када му је дозвољено да једе.
//Користити System.currentTimeMillis() за дохватање времена и 
//дозвоњено је користити Future и друге синхронизационе примитиве за решавање задатка.
public class Server {
	private int port;
	ExecutorService pool;
	public static final int NUM_OF_PHILOSOPHERS = 30;
	 
	public Server(int  port) {
		this.port = port;
		this.pool = Executors.newFixedThreadPool(10);
		
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
		   } catch (InterruptedException ie) {
		     // (Re-)Cancel if current thread also interrupted
		     pool.shutdownNow();
		     // Preserve interrupt status
		     Thread.currentThread().interrupt();
		   }
	}
	public void start() {
		try (ServerSocket serverSocket = new ServerSocket(port);){
			int i = 0;
			while(i < 5*5) {
				
				Socket client = serverSocket.accept();
					
				System.out.println("Accepted");
				pool.execute(new ServerConnectionThread(client, this));
				
				Future<Integer> future = pool.submit(new Callable<Integer>() {
					@Override
					public Integer call() throws Exception {
						// TODO Auto-generated method stub
						return 5;
					}

				});
				
				
				System.out.println( future.get());
				
				
				i++;
	
			}
		} catch (Exception e) {
			System.err.println(e);
		}
		System.out.println("Closing server.");
		shutdownAndAwaitTermination(pool);
	}
	
	public static void main(String[] args) {
		new Server(Integer.parseInt(args[0])).start();
	}
}
