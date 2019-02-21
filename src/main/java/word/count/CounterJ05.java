package word.count;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.UncheckedIOException;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

public final class CounterJ05 implements Counter {

    @Override
    public List<String> extractWords(String path) {
        LinkedList<String> words = new LinkedList<>();
        try ( Scanner sc = new Scanner( new FileReader( path ) ) ) {
            while ( sc.hasNext() ) {
                String word = sc.next();
                // consider words 3+ letters long
                if ( word.length() > 2 ) {
                    words.add( word.toLowerCase() );
                }
            }
        } catch ( FileNotFoundException e ) {
            throw new UncheckedIOException( e );
        }
        return words;
    }

    @Override
    public Map<String, ? extends Number> countWords(List<String> words) {
        HashMap<String, AtomicInteger> wordCounters = new HashMap<>( words.size() >> 1 );
        for ( String word : words ) {
            AtomicInteger counter = wordCounters.get( word );
            if ( counter == null ) {
                counter = new AtomicInteger();
                wordCounters.put( word, counter );
            }
            counter.getAndIncrement();
        }
        return wordCounters;
    }

    @Override
    public List<WordFrequency> mostFrequentWords(Map<String, ? extends Number> wordCounts, int totalWordCount, int limit) {
        ArrayList<? extends Map.Entry<String, ? extends Number>> wordCountsList = new ArrayList<>( wordCounts.entrySet() );
        Collections.<Map.Entry<String, ? extends Number>> sort(
                (List<Map.Entry<String, ? extends Number>>) wordCountsList,
                new Comparator<Map.Entry<String, ? extends Number>>() {
                    @Override
                    public int compare(Map.Entry<String, ? extends Number> o1, Map.Entry<String, ? extends Number> o2) {
                        int res = o2.getValue().intValue() - o1.getValue().intValue();
                        if (res == 0) {
                            res = o1.getKey().compareTo( o2.getKey() );
                        }
                        return res;
                    }
                } );
        ArrayList<WordFrequency> wordFrequencies = new ArrayList<>( limit );
        for ( int i = 0, count = Math.min( wordCountsList.size(), limit + 1 ); i < count; ++i ) {
            Map.Entry<String, ? extends Number> wordCount = wordCountsList.get( i );
            wordFrequencies.add(
                    new WordFrequency(
                            wordCount.getKey(),
                            wordCount.getValue().intValue(),
                            totalWordCount
                    )
            );
        }
        return wordFrequencies;
    }
}
