package com.trivadis.word.count;

import java.util.Collection;
import java.util.Map;

public interface Counter {
    int WORD_LENGTH_THRESHOLD = 4;

    Collection<String> extractWords(String path);
    Map<String, ? extends Number> countWords(Collection<String> words);
    Collection<WordFrequency> mostFrequentWords(Map<String, ? extends Number> wordCounts, int totalWordCount, int limit);
}
