package model;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

public class Text {
	
	String title;
	List<String> words;

	// Constructor required for COMPSs
	public Text() {
		System.out.println("[ Text ] Call to empty constructor (for COMPSs).");
	}

	// Constructor for TextCollection to build new text objects
	public Text(String newTitle) {
		this.title = newTitle;
		this.words = new ArrayList<String>();
	}

	public String getTitle() {
		return title;
	}

	public void addWords(List<String> newwords) throws IOException {
		this.words.addAll(newwords);
	}

	public TextStats wordCount() {
		HashMap<String, Integer> result = new HashMap<String, Integer>();
		Iterator<String> it = words.iterator();
		while (it.hasNext()) {
			String word = it.next();
			Integer curCount = result.get(word);
			if (curCount == null) {
				result.put(word, 1);
			} else {
				result.put(word, curCount + 1);
			}
		}
		TextStats textStats = new TextStats(result);
		return textStats;
	}
}
