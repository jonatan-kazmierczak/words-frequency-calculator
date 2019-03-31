package com.trivadis.word.count;

import java.util.List;
import java.util.Map;

public interface Counter {
    int WORD_LENGTH_THRESHOLD = 4;

    List<String> extractWords(String path);
    Map<String, ? extends Number> countWords(List<String> words);
    List<WordFrequency> mostFrequentWords(Map<String, ? extends Number> wordCounts, int totalWordCount, int limit);
}
