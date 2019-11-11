package model;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class TextCollectionIndex  {
	ArrayList<TextCollection> textCollections;
	int nextCollection;

	public TextCollectionIndex(ArrayList<TextCollection> newTextCollections) {
		textCollections = new ArrayList<TextCollection>();
		textCollections.addAll(newTextCollections);
		nextCollection = 0;
	}

	public ArrayList<String> getTextTitles() {
		ArrayList<String> result = new ArrayList<String>();
		for (TextCollection tc : textCollections) {
			result.addAll(tc.getTextTitles());
		}
		return result;
	}

	public int getSize() {
		int result = 0;
		for (TextCollection tc : textCollections) {
			result += tc.getSize();
		}
		return result;
	}

	public ArrayList<TextCollection> getTextCollections() { 
		return textCollections;
	}
	
	public int getNextCollection() { 
		return nextCollection;
	}
	
	public void setNextCollection(final int nc) { 
		this.nextCollection = nc;
	}
	
}
