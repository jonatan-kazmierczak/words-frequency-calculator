package word.count;

import java.util.Collections;
import java.util.List;
import java.util.Map;

public final class CounterJ07 implements Counter {

    @Override
    public List<String> extractWords(String path) {
        return Collections.emptyList();
    }

    @Override
    public Map<String, Integer> countWords(List<String> words) {
        return Collections.emptyMap();
    }

    @Override
    public List<WordFrequency> mostFrequentWords(Map<String, Integer> wordCounts, int limit) {
        return Collections.emptyList();
    }
}
