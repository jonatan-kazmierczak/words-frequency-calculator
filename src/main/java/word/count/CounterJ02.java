package word.count;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

public final class CounterJ02 implements Counter {

    @Override
    public List<String> extractWords(String path) {
        //LinkedList<String> words = new LinkedList<>();
        ArrayList<String> words = new ArrayList<>( 0x1000 );
        try ( BufferedReader reader = new BufferedReader( new FileReader( path ) ) ) {
            for ( String line = reader.readLine(); line != null; line = reader.readLine() ) {
                StringTokenizer tokenizer = new StringTokenizer( line );
                while ( tokenizer.hasMoreElements() ) {
                    String word = tokenizer.nextToken();
                    // consider words 3+ letters long
                    if ( word.length() > 2 ) {
                        words.add( word.toLowerCase() );
                    }
                }
            }
        } catch ( IOException e ) {
            throw new UncheckedIOException( e );
        }
        return words;
    }

    @Override
    public Map<String, ? extends Number> countWords(List<String> words) {
        HashMap<String, Integer> wordCounters = new HashMap<>( words.size() >> 1 );
        for ( String word : words ) {
            Integer counter = wordCounters.get( word );
            counter = (counter == null) ? 1 : counter + 1;
            wordCounters.put( word, counter );
        }
        return wordCounters;
    }

    @Override
    public List<WordFrequency> mostFrequentWords(Map<String, ? extends Number> wordCounts, int totalWordCount, int limit) {
        return Collections.emptyList();
    }
}
