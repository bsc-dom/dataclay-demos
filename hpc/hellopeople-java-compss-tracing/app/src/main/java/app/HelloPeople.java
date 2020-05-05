package app;

import es.bsc.dataclay.api.DataClay;
import es.bsc.dataclay.commonruntime.ClientManagementLib;
import es.bsc.dataclay.DataClayObject;
import es.bsc.compss.api.COMPSs;
import model.People;
import model.Person;
import org.apache.logging.log4j.LogManager;

public class HelloPeople {
	
	public static void addPerson(final People people, final int index) { 
		Person person = new Person("Untitled Meatbag", 18 + index);
		people.add(person);
	}

	public static void main(String[] args) throws Exception {

		// Access (or create collection)
		People people = new People();
		people.makePersistent("MeatbagMeeting");
		
		int numWorkers = 2;
		int numPersons = 48 * 2;
		for (int i = 0; i < numPersons; i++) { 
			addPerson(people, i);
		}

		COMPSs.barrier();
		
		// Print people (people iterated remotely)
		System.out.println(people);
		
		System.out.println("APPLICATION FINISHED! Wait for dataClay and COMPSs Shutdown...");
		String home = System.getProperty("user.home");
		String jobId = System.getenv().get("SLURM_JOBID");
		System.out.println("REMEMBER: Traces will be stored at " + home + "/.COMPSs/" + jobId + "/trace");
	}
}
