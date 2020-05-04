package app;
import es.bsc.compss.types.annotations.task.Method;
import es.bsc.compss.types.annotations.Parameter;
import es.bsc.compss.types.annotations.parameter.Direction;
import es.bsc.compss.types.annotations.parameter.Type;
import model.People;

public interface HelloPeopleItf {
	@Method(declaringClass = "app.HelloPeople")
	public void addPerson(@Parameter(type = Type.OBJECT, direction = Direction.INOUT) People people,
			@Parameter(type = Type.INT) int index);

}
