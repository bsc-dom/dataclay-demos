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
	List<String> words1;
	boolean debug;

	// Constructor required for COMPSs
	public Text() {
		System.out.println("[ Text ] Call to empty constructor (for COMPSs).");
	}

	// Constructor for TextCollection to build new text objects
	public Text(String newTitle, boolean doDebug) {
		this.title = newTitle;
		this.words1 = new ArrayList<String>();
		this.debug = doDebug;
		if (debug) {
			System.out.println(
					"[ Text ] Call to real constructor to create a text object with " + words1.getClass().getName());
		}
	}

	public String getTitle() {
		return title;
	}

	public void addWords(String filePath) throws IOException {
		File file = new File(filePath);
		FileReader fr = new FileReader(file);
		BufferedReader br = new BufferedReader(fr);
		String line;
		int addedWords = 0;
		long totalSize = file.length();
		System.out
				.println("[ Text ] Parsing file " + file.getName() + " of size " + totalSize / 1024 / 1024 + " MB ...");
		long init = System.currentTimeMillis();
		while ((line = br.readLine()) != null) {
			String[] wordsLine = line.split(" ");
			for (String word : wordsLine) {
				words1.add(word);
				addedWords++;
			}
		}
		long end = System.currentTimeMillis();
		System.out.println("[ Text ] Added : " + addedWords + " words in " + (end - init) + " ms");

		br.close();
		fr.close();
	}

	public TextStats wordCount(final boolean persistStats) {
		long start = 0, end = 0;
		if (debug) {
			start = System.currentTimeMillis();
		}
		HashMap<String, Integer> result = new HashMap<String, Integer>();
		Iterator<String> it = words1.iterator();
		while (it.hasNext()) {
			String word = it.next();
			Integer curCount = result.get(word);
			if (curCount == null) {
				result.put(word, 1);
			} else {
				result.put(word, curCount + 1);
			}
		}
		if (debug) {
			end = System.currentTimeMillis();
			System.out.println("[ Text ] Computed text " + title + " in " + (end - start) + " millis");
		}
		TextStats textStats = new TextStats(result, debug);
		return textStats;
	}

	public int wordCountNotComputing() {
		int i = 0;
		Iterator<String> it = words1.iterator();
		while (it.hasNext()) {
			it.next();
			i++;
		}
		return i;
	}
}
