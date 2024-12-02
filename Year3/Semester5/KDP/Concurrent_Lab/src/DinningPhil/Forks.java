package DinningPhil;

public class Forks {
	int ticket = 0;
	int next = 0;
	int[] status = new int[Shared.N]; 
	{
		for (int i = 0; i < status.length; i++)
			status[i] = 0;
	}
}
