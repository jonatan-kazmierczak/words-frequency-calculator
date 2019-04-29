package com.trivadis.words.frequency;

import java.util.Collection;
import java.util.Map;

public interface Calculator {
    int WORD_LENGTH_THRESHOLD = 0;

    Collection<String> extractWords(String path);
    Map<String, ? extends Number> countWords(Collection<String> words);
    Collection<WordFrequency> getMostFrequentWords(
            Map<String, ? extends Number> wordCounts, int totalWordCount, int limit);
}
