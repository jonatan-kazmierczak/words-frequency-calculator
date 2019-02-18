package word.count;

import java.util.Collections;
import java.util.List;
import java.util.Map;

public final class CounterJ08Parallel implements Counter {

    @Override
    public List<String> extractWords(String path) {
        return Collections.emptyList();
    }

    @Override
    public Map<String, ? extends Number> countWords(List<String> words) {
        return Collections.emptyMap();
    }

    @Override
    public List<WordFrequency> mostFrequentWords(Map<String, ? extends Number> wordCounts, int limit) {
        return Collections.emptyList();
    }
}
