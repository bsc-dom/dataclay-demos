package model;

import java.io.IOException;
import java.util.ArrayList;

public class TextCollection {
	String textPrefix;
	ArrayList<String> textTitles;
	boolean debug;

	public TextCollection(String prefixForTextsInCollection, boolean doDebug) {
		this.textTitles = new ArrayList<String>();
		this.textPrefix = prefixForTextsInCollection;
		this.debug = doDebug;
	}

	public String getTextPrefix() {
		return textPrefix;
	}

	public ArrayList<String> getTextTitles() {
		return textTitles;
	}

	public int getSize() {
		return textTitles.size();
	}

	public String addTextFromFile(final String filePath) throws IOException {
		String textTitle = textPrefix + ".file" + (textTitles.size() + 1);
		Text t = new Text(textTitle, debug);
		t.makePersistent(textTitle);
		textTitles.add(textTitle);
		t.addWords(filePath);
		return textTitle;
	}
}
