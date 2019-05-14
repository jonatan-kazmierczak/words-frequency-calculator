package com.trivadis.words.frequency;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Implementation using Java standard library 1.7
 */
public final class CalculatorJ7 implements Calculator {

    @Override
    public Collection<String> extractWords(String path) {
        ArrayList<String> words = new ArrayList<>( 0x1000 );
        try ( Scanner scanner = new Scanner( Files.newBufferedReader( Paths.get( path ) ) ) ) {
            while ( scanner.hasNext() ) {
                String word = scanner.next();
                if ( word.length() > WORD_LENGTH_THRESHOLD ) {
                    words.add( word.toLowerCase() );
                }
            }
        } catch ( IOException e ) {
            throw new RuntimeException( e );
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
    public Collection<WordFrequency> getMostFrequentWords(
            Map<String, ? extends Number> wordCounts, int totalWordCount, int limit) {
        ArrayList<? extends Map.Entry<String, ? extends Number>> wordCountsList
                = new ArrayList<>( wordCounts.entrySet() );
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
