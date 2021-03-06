package com.trivadis.words.frequency;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.Collections;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Implementation using Java standard library 1.8
 */
public final class CalculatorJ8 implements Calculator {

    @Override
    public Collection<String> extractWords(String path) {
        try ( Stream<String> fileLines = Files.lines( Paths.get( path ) ) ) {
            return fileLines
                    .map( line -> line.split( "\\p{javaWhitespace}+" ) )
                    .flatMap( Stream::of )
                    .filter( word -> word.length() > WORD_LENGTH_THRESHOLD )
                    .map( String::toLowerCase )
                    .collect( Collectors.toList() );
        } catch ( IOException e ) {
            throw new UncheckedIOException( e );
        }
    }

    @Override
    public Map<String, ? extends Number> countWords(Collection<String> words) {
        return words.stream().collect(
                Collectors.groupingBy( Function.identity(), Collectors.counting() )
        );
    }

    @Override
    public Collection<WordFrequency> getMostFrequentWords(
            Map<String, ? extends Number> wordCounts, int totalWordCount, int limit) {
        return wordCounts.entrySet().stream()
                .sorted( Map.Entry.comparingByValue( Collections.reverseOrder() ) )
                .limit( limit )
                .map( e -> new WordFrequency( e.getKey(), e.getValue().intValue(), totalWordCount ) )
                .collect( Collectors.toList() );
    }
}
