package DinningPhil;


public class Shared {
//	Решити Dining Philosophers проблем користећи AtomicInteger и регионе.
//	филозофи који су раније изразили жељу за храном треба раније да буду опслужени . 
//	Потребно је да програм буде максимално конкурентан и отпоран на прекиде
	static final int N = 5;
	static Forks forks = new Forks();
	public static void main(String[] args) throws InterruptedException {
		Phil phils[] = new Phil[N];
		for(int i=0; i<N; i++) {
			phils[i] = new Phil(i);
			phils[i].start();
		}
		
//		Thread.sleep((int)(Math.random() * 3000+10000));
//		 
//		for(int i=0; i<N; i++) {
//			phils[i].interrupt();
//		}
//		System.out.println("Kraj");
//	
	}
}
