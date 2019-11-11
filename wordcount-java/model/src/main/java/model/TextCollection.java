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
	
	public void addTextTitle(final String newTextTitle) { 
		this.textTitles.add(newTextTitle);
	}

	public int getSize() {
		return textTitles.size();
	}

	
}
