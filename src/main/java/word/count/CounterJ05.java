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
        //LinkedList<String> words = new LinkedList<>();
        ArrayList<String> words = new ArrayList<>( 0x1000 );
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
    public List<WordFrequency> mostFrequentWords(Map<String, ? extends Number> wordCounts, int totalWordCount, int limit) {
        ArrayList<? extends Map.Entry<String, ? extends Number>> wordCountsList = new ArrayList<>( wordCounts.entrySet() );
        Collections.sort(
                wordCountsList,
                new Comparator<Map.Entry<String, ? extends Number>>() {
                    @Override
                    public int compare(Map.Entry<String, ? extends Number> e1, Map.Entry<String, ? extends Number> e2) {
                        return e2.getValue().intValue() - e1.getValue().intValue();
                    }
                } );
        ArrayList<WordFrequency> wordFrequencies = new ArrayList<>( limit );
        for ( int i = 0, count = Math.min( wordCountsList.size(), limit ); i < count; ++i ) {
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
