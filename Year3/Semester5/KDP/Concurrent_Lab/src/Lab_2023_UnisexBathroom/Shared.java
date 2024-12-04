package Lab_2023_UnisexBathroom;

import java.util.Iterator;

public class Shared {
//	Постоји тоалет капацитета N (N > 1) који могу да
//	користе жене и мушкарци, такав да се у исто
//	време у тоалету не могу наћи и жене и мушкарци.
//	Написати програм за жене и мушкарце који
//	долазе до тоалета, користе га и напуштају га
//	користећи reentrantLock. Избећи изгладњавање
//	
	static final int Mcnt = 10;
	static final int Wcnt = 2;
	static final int N = Mcnt+Wcnt;
	static Bathroom bathroom = new Bathroom();
	public static void main(String[] args) {
		People[] people = new People[N];
		
		
		for(int i = 0; i<Mcnt; i++)
			people[i] = new Man();
			
		for(int i = Mcnt; i<N; i++)
			people[i] = new Woman();
		
	
		for(int i = 0; i<N; i++)
			people[i].start();
		
	}
}
