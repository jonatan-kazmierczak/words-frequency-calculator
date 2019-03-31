package com.trivadis.word.count;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class CounterJ8Prl implements Counter {

    @Override
    public List<String> extractWords(String path) {
        try ( Stream<String> fileLines = Files.lines( Paths.get( path ) ) ) {
            return fileLines.parallel().unordered()
                    .map( line -> line.split( "\\p{javaWhitespace}+" ) )
                    .flatMap( wordArr -> Stream.of( wordArr ).parallel().unordered() )
                    .filter( word -> word.length() > WORD_LENGTH_THRESHOLD )
                    .map( String::toLowerCase )
                    .collect( Collectors.toList() );
        } catch ( IOException e ) {
            throw new UncheckedIOException( e );
        }
    }

    @Override
    public Map<String, ? extends Number> countWords(List<String> words) {
        return words.parallelStream().unordered()
                .collect( Collectors.groupingByConcurrent( word -> word, Collectors.summingInt( word -> 1 ) ) );
    }

    @Override
    public List<WordFrequency> mostFrequentWords(Map<String, ? extends Number> wordCounts, int totalWordCount, int limit) {
        return wordCounts.entrySet().parallelStream().unordered()
                .sorted( Map.Entry.comparingByValue( Collections.reverseOrder() ) )
                .limit( limit )
                .map( e -> new WordFrequency( e.getKey(), e.getValue().intValue(), totalWordCount ) )
                .collect( Collectors.toList() );
    }
}
