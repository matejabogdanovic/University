package rs.ac.bg.etf.kdp.net.protocol;

import java.util.HashSet;
import java.util.Set;

import rs.ac.bg.etf.kdp.net.communicator.Communicator;

public class ServerProtocolKnockKnock extends OneCommunicatorProtocol {

	private static final int WAITING = 0;
	private int state = WAITING;

	public static String[] eggs = { "Belo", "Plavo", "Crveno", "Zeleno", "Zuto", "Crno" };
	private static Set<String> eggsSet = new HashSet<String>();
	public static String[] questions = { "Kuc kuc", "Djavo 's neba", "Jedno jaje" };
	public static String[] answers = { "Ko je?", "Sta Vam treba?", "Koje boje?" };
	public static String yesAnswer = "Ima. ";
	public static String noAnswer = "Nema ";
	public static String byeAnswer = "Zdravo!";

	public ServerProtocolKnockKnock() {
		super();
	}

	@Override
	public void conversation() {
		try (Communicator communicator = getCommunicator();) {
			String outputLine = null;
			String inputLine = null;
			while ((inputLine = communicator.readString()) != null) {
				System.out.println("Klijent: " + inputLine);
				outputLine = processInput(inputLine);
				communicator.writeString(outputLine);
				System.out.println("Server: " + outputLine);
				if (outputLine.equalsIgnoreCase(byeAnswer))
					break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String processInput(String input) {
		String output = null;
		if (input == null)
			input = "";
		switch (state) {
			case 0:
			case 1:
			case 2:
				if (input.equalsIgnoreCase(questions[state])) {
					output = answers[state];
					state++;
				}
				else {
					output = byeAnswer;
					state = 0;
				}
				break;
			case 3:
				if (eggsSet.contains(input.toLowerCase())) {
					output = yesAnswer;
					state++;
				}
				else {
					output = noAnswer + input + ". " + answers[2];
				}
				break;
			default:
				output = byeAnswer;
				break;
		}
		return output;
	}

	static {
		for (String egg : eggs) {
			eggsSet.add(egg.toLowerCase());
		}
	}
}
