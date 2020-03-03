package app;

import es.bsc.dataclay.api.DataClay;
import storage.StorageItf;

public class NewVersion {
	private static void usage() {
		System.out.println("Usage: application.NewVersion <objectID> <backendID> ");
		System.exit(-1);
	}

	public static void main(String[] args) throws Exception {
		// Check and parse arguments
		if (args.length != 2) {
			usage();
		}
		String id = args[0];
		String destinationBackend = args[1];

		System.out.println("[LOG] Creating new version for id " + id + " to backend " + destinationBackend);

		// Init dataClay session
		StorageItf.init(System.getenv("DATACLAYSESSIONCONFIG"));

		// Creating new version
		String versionID = StorageItf.newVersion(id, false, destinationBackend);
		System.out.println("Version ID: " + versionID);

		// Finish dataClay session
		StorageItf.finish();
		
		// Call this to shutdown all logging threads
		System.exit(0);
	}
}
