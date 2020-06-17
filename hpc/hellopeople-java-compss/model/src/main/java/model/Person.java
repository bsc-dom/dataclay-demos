package model;
import es.bsc.dataclay.DataClayObject;

public class Person extends DataClayObject {
	String name;
	int age;

	public Person(String newName, int newAge) {
		name = newName;
		age = newAge;
	}

	public String getName() {
		return name;
	}

	public int getAge() {
		return age;
	}
}
