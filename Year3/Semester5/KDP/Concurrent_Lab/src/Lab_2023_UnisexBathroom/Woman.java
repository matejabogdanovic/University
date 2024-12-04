package Lab_2023_UnisexBathroom;

public class Woman extends People {
	public Woman() {
		
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
			Shared.bathroom.enterW();
			System.out.print("W");
			try {
				Thread.sleep((int)Math.random()*1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Shared.bathroom.exitW();
		}
	}
}
