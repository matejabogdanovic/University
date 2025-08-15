package Honey;

// main samo da bi u relativno isto vreme pokrenuli bee i bear
public class Main {
	public static void main(String[] args) {
		for (int i = 0; i < 5; i++) {
			if(i==0)new Bear(args[0], Integer.parseInt(args[1])).start();
			new Bee(args[0], Integer.parseInt(args[1]),i ).start();
		}
	}
}
