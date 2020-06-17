package app;

import es.bsc.dataclay.api.DataClay;
import es.bsc.dataclay.commonruntime.ClientManagementLib;
import es.bsc.dataclay.DataClayObject;
import es.bsc.compss.api.COMPSs;
import model.People;
import model.Person;
import org.apache.logging.log4j.LogManager;

public class HelloPeople {
	
	public static void addPerson(People people, int index) { 
		Person person = new Person("Untitled Meatbag", 18 + index);
		people.add(person);
	}

	public static void main(String[] args) throws Exception {

		// Access (or create collection)
		People people = new People();
		people.makePersistent("MeatbagMeeting");
		for (int i = 0; i < 20; i++) { 
			addPerson(people, i);
		}

		COMPSs.barrier();
		
		// Print people (people iterated remotely)
		System.out.println(people);
		System.out.println("APPLICATION FINISHED!");
	}
}
