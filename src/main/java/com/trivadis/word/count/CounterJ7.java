package com.trivadis.word.count;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Implementation using Java standard library 1.7
 */
public final class CounterJ7 implements Counter {

    @Override
    public Collection<String> extractWords(String path) {
        ArrayList<String> words = new ArrayList<>( 0x2000 );
        try ( Scanner sc = new Scanner( Files.newBufferedReader( Paths.get( path ) ) ) ) {
            while ( sc.hasNext() ) {
                String word = sc.next();
                if ( word.length() > WORD_LENGTH_THRESHOLD ) {
                    words.add( word.toLowerCase() );
                }
            }
        } catch (IOException e ) {
            throw new UncheckedIOException( e );
        }
        return words;
    }

    @Override
    public Map<String, ? extends Number> countWords(Collection<String> words) {
        HashMap<String, AtomicInteger> wordCounters = new HashMap<>( words.size() >> 2 );
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
    public Collection<WordFrequency> mostFrequentWords(Map<String, ? extends Number> wordCounts, int totalWordCount, int limit) {
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
