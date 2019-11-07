package app;

import es.bsc.dataclay.api.DataClay;
import model.People;
import model.Person;

public class HelloPeople {
	private static void usage() {
		System.out.println("Usage: application.HelloPeople <peopleAlias> <personName> <personAge>");
		System.exit(-1);
	}

	public static void main(String[] args) throws Exception {
		// Check and parse arguments
		if (args.length != 3) {
			usage();
		}
		String peopleAlias = args[0];
		String pName = args[1];
		int pAge = Integer.parseInt(args[2]);
		System.out.println("[LOG] People alias: " + peopleAlias);
		System.out.println("[LOG] Person name: " + pName);
		System.out.println("[LOG] Person age: " + pAge);

		// Init dataClay session
		DataClay.init();

		// Create person
		Person person = new Person(pName, pAge);
		person.makePersistent();
		
		// Access (or create collection)
		People people = null;
		try {
			people = People.getByAlias(peopleAlias);
			System.out.println("[LOG] People object " + peopleAlias + " found.");
		} catch (Exception ex) {
			System.out.println("[LOG] Creating NEW object People");
			people = new People();
			try {
				people.makePersistent(peopleAlias);
			} catch (Exception e) { 
				e.printStackTrace();
			}
		}

		// person is added to people
		people.add(person);

		// Print people (people iterated remotely)
		System.out.println(people);

		// Finish dataClay session
		DataClay.finish();
	}
}
