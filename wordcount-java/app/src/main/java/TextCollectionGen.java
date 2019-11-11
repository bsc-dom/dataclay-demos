
import java.io.File;
import java.util.ArrayList;
import java.util.List;

// import dataclay.collections.DataClayArrayList;
import model.Text;
import model.TextCollection;
import model.TextCollectionIndex;
import storage.StorageItf;
import es.bsc.dataclay.api.BackendID;
import es.bsc.dataclay.api.DataClay;
import java.io.IOException;

public class TextCollectionGen {
	static int timesPerFile = 3;
	public static void main(String[] args) throws Exception {
		if (args.length < 2) {
			printErrorUsage();
			return;
		}
		final String textColAlias = args[0];
		final String remoteFilePath = args[1];
		DataClay.init();

		// Try to retrieve a previously created text collection
		TextCollectionIndex textCollectionIndex = null;
		try {
			textCollectionIndex = (TextCollectionIndex) TextCollectionIndex.getByAlias(textColAlias);
			System.out.println("[LOG] Found collection index with " + textCollectionIndex.getSize() + " files");
		} catch (Exception ex) {
			System.out.println("[LOG] No previous collection index found.");
			ArrayList<TextCollection> tcs = new ArrayList<TextCollection>();
			int id = 1;

			// Distributed index among N collections, one per Backend.
			for (BackendID locID : DataClay.getJBackends().keySet()) {
				String prefixForTexts = textColAlias + id;
				TextCollection tc = new TextCollection(prefixForTexts, false);

				tc.makePersistent(prefixForTexts, locID);
				System.out.println("[LOG] Collection created at " + tc.getLocation());

				tcs.add(tc);
				id++;
			}
			textCollectionIndex = new TextCollectionIndex(tcs);
			System.out.println(
					"[LOG] Created new collection index. Is persistent? " + textCollectionIndex.isPersistent());
			textCollectionIndex.makePersistent(textColAlias);
			System.out.println(
					"[LOG] Created new collection index. Is persistent? " + textCollectionIndex.isPersistent());
		}
		System.out.println("[LOG] Collection index id " + textCollectionIndex.getID());
		System.out.println("[LOG] Collection index located at " + textCollectionIndex.getLocation());
		System.out.println("[LOG] Collection index current size " + textCollectionIndex.getSize());

		// Add text files to the index.
		// Internally, text objects are created from text files, and stored in a round
		// robin fashion among the distributed index.
		List<String> textTitles = new ArrayList<String>();
		for (int i = 0; i < timesPerFile; i++) {
			try {
				textTitles = addTextsFromPath(textCollectionIndex, remoteFilePath);
			} catch (Exception ex) {
				System.err.println("[ERROR] Could not add texts from path " + remoteFilePath
						+ ". Is it a valid path in the backend?. Exception msg: " + ex.getMessage());
				break;
			}

			System.out.println("[LOG] Updated collection. Now it has " + textCollectionIndex.getSize() + " files.");
			for (String textTitle : textTitles) {
				Text t = (Text) Text.getByAlias(textTitle);
				System.out.println("[LOG] New text " + textTitle + " is located at " + t.getLocation());
			}
		}
		DataClay.finish();

		// Shutdown logger threads
		System.exit(0);
	}

	public static List<String> addTextsFromPath(final TextCollectionIndex tci, final String filePath) throws IOException {
		List<String> result;
		File f = new File(filePath);
		if (f.isDirectory()) {
			result = addTextsFromDir(tci, filePath);
		} else {
			result = new ArrayList<String>();
			String newTitle = addTextFromFile(tci, filePath);
			result.add(newTitle);
		}
		return result;
	}

	public static String addTextFromFile(final TextCollectionIndex tci, final String filePath) throws IOException {
		ArrayList<TextCollection> textCollections = tci.getTextCollections();
		int nextCollection = tci.getNextCollection();
		if (nextCollection == textCollections.size()) {
			nextCollection = 0;
		}
		TextCollection tc = textCollections.get(nextCollection);
		ArrayList<String> textTitles = tc.getTextTitles();
		tci.setNextCollection(nextCollection++);		
		String textPrefix = tc.getTextPrefix();
		String textTitle = textPrefix + ".file" + (textTitles.size() + 1);
		Text t = new Text(textTitle, false);
		t.addWords(filePath);
		t.makePersistent(textTitle);
		tc.addTextTitle(textTitle);
		return textTitle;
	}
	
	public static List<String> addTextsFromDir(final TextCollectionIndex tci, final String dirPath) throws IOException {
		File dir = new File(dirPath);
		List<String> result = new ArrayList<String>();
		for (File f : dir.listFiles()) {
			String addedText = addTextFromFile(tci, f.getAbsolutePath());
			result.add(addedText);
		}
		return result;
	}
	
	/**
	 * @brief print application usage
	 */
	private static void printErrorUsage() {
		System.err.println("Bad arguments. Usage: \n\n" + TextCollectionGen.class.getName()
				+ " <text_col_alias> <remote_path> " + " \n");
	}
}