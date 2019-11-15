package model;

import java.util.HashMap;
import java.util.Map.Entry;

public class TextStats {
	
	HashMap<String, Integer> wordcount;

	public TextStats() {
		wordcount = new HashMap<String, Integer>();
	}

	public TextStats(HashMap<String, Integer> newWordCount) {
		wordcount = new HashMap<String, Integer>();
		wordcount.putAll(newWordCount);
	}

	public void setWordCount(HashMap<String, Integer> newWordCount) {
		wordcount.putAll(newWordCount);
	}

	public HashMap<String, Integer> getWordCount() {
		return wordcount;
	}

	public int getSize() {
		return wordcount.size();
	}

	public void mergeWordCounts(final TextStats newWordCount) {

		HashMap<String, Integer> wordCountToMerge = newWordCount.getWordCount();
		for (Entry<String, Integer> entry : wordCountToMerge.entrySet()) {
			String word = entry.getKey();
			Integer count = entry.getValue();
			Integer curCount = wordcount.get(word);
			if (curCount == null) {
				wordcount.put(word, count);
			} else {
				wordcount.put(word, curCount + count);
			}
		}
	}

	public HashMap<String, Integer> getSummary(int maxEntries) {
		int i = 0;
		HashMap<String, Integer> result = new HashMap<String, Integer>();
		for (Entry<String, Integer> curEntry : wordcount.entrySet()) {
			result.put(curEntry.getKey(), curEntry.getValue());
			i++;
			if (i == maxEntries) {
				break;
			}
		}
		return result;
	}

}
