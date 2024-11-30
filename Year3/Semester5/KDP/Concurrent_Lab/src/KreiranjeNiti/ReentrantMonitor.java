package KreiranjeNiti;

public class ReentrantMonitor {
	public synchronized void a() {
		b();
		System.out.println("here I am, in a()");
	}
	public synchronized void b() {
		System.out.println("here I am, in b()");
	}
}