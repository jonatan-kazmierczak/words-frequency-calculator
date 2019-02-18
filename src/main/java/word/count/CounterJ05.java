package word.count;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.UncheckedIOException;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

public final class CounterJ05 implements Counter {

    @Override
    public List<String> extractWords(String path) {
        LinkedList<String> words = new LinkedList<>();
        try ( Scanner sc = new Scanner( new BufferedReader( new FileReader( path ) ) ) ) {
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
    public List<WordFrequency> mostFrequentWords(Map<String, ? extends Number> wordCounts, int limit) {
        for ( Map.Entry<String, ? extends Number> wordCounter : wordCounts.entrySet() ) {

        }
        return Collections.emptyList();
    }
}
