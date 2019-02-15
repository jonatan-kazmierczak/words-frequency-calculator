package word.count;

import java.util.List;
import java.util.Map;

public interface Counter {
    List<String> extractWords(String path);
    Map<String, Integer> countWords(List<String> words);
    List<WordFrequency> mostFrequentWords(Map<String, Integer> wordCounts, int limit);
}
