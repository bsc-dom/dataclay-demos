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
		System.out.println("[LOG] Creating " + pName);
		Person person = new Person(pName, pAge);
		person.makePersistent();
		System.out.println("[LOG] " + pName + " created ");
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
				System.out.println("[LOG] People created ");
			} catch (Exception e) { 
				e.printStackTrace();
			}
		}
		System.out.println("[LOG] Adding " + pName + " to People ");
		// person is added to people
		people.add(person);

		// Print people (people iterated remotely)
		System.out.println(people);

		// Finish dataClay session
		DataClay.finish();
		
		// Call this to shutdown all logging threads
		System.exit(0);
	}
}
