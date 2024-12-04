package Lab_2023_UnisexBathroom;

public class Man extends People {
	public Man() {

	}
	@Override
	public void run() {
		while(true) {
			try {
				Thread.sleep((int)Math.random()*1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Shared.bathroom.enterM();
			System.out.print("M");
			try {
				Thread.sleep((int)Math.random()*1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Shared.bathroom.exitM();
		}
	}
}
