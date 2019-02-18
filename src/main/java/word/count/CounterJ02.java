package word.count;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class CounterJ02 implements Counter {

    @Override
    public List<String> extractWords(String path) {
        return Collections.emptyList();
    }

    @Override
    public Map<String, ? extends Number> countWords(List<String> words) {
        HashMap<String, Integer> wordCounters = new HashMap<>( words.size() >> 1 );
        return Collections.emptyMap();
    }

    @Override
    public List<WordFrequency> mostFrequentWords(Map<String, ? extends Number> wordCounts, int limit) {
        return Collections.emptyList();
    }
}
