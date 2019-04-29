package com.trivadis.words.frequency;

import java.util.Collection;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class App {
    public static void main(String[] args) {
        // Explicit instantiation required by native-image compiler (from GraalVM)
        Map<String, Calculator> implementations = Stream.of(
                new CalculatorJ2(),
                new CalculatorJ5(),
                new CalculatorJ7(),
                new CalculatorJ8(),
                new CalculatorJ8Prl()
        ).collect( Collectors.toMap( c -> c.getClass().getSimpleName(), c -> c, (l, r) -> l, TreeMap::new ) );

        if ( args.length < 2 || !implementations.containsKey( args[0] ) ) {
            String usage = String.format(
                    "Required parameters:%n" +
                            "\tclass_name: one of %s%n" +
                            "\tpath: path to text file%n" +
                    "Optional parameter:%n" +
                            "\trepeat_count: number of repeatations (default: 1), turns on quiet mode when provided%n%n",
                    implementations.keySet()
            );
            System.out.println(usage);
            throw new AssertionError( "Missing class_name and/or path" );
        }

        Calculator calculator = implementations.get( args[0] );
        String path = args[1];
        boolean beQuiet = args.length > 2;
        
        int repeatCount = 1;
        try {
            repeatCount = Integer.parseInt( args[2] );
        } catch (RuntimeException e) {
            // Ignore
        }
        
        for (int i = 0; i < repeatCount; ++i) {
            run( calculator, path, beQuiet );
        }
    }

    private static void run(Calculator calculator, String path, boolean beQuiet) {
        StopWatch totalStopWatch = new StopWatch();

        StopWatch extractWordsStopWatch = new StopWatch();
        Collection<String> words = calculator.extractWords( path );
        int totalWordCount = words.size();
        extractWordsStopWatch.stop();

        StopWatch countWordsStopWatch = new StopWatch();
        Map<String, ? extends Number> countWords = calculator.countWords( words );
        int uniqueWordCount = countWords.size();
        countWordsStopWatch.stop();

        StopWatch wordFrequenciesStopWatch = new StopWatch();
        Collection<WordFrequency> wordFrequencies = calculator.getMostFrequentWords( countWords, totalWordCount, 15 );
        wordFrequenciesStopWatch.stop();

        totalStopWatch.stop();

        if (!beQuiet) {
            System.out.printf( "%d considered words %n%d unique words%n%n", totalWordCount, uniqueWordCount );
            // Print word frequencies
            for (WordFrequency wordFrequency : wordFrequencies) {
                System.out.println( wordFrequency );
            }

            System.out.println( "\n# Implementation,Total_Processing_Time,extractWords_Time,countWords_Time,getMostFrequentWords_Time" );
        }

        // Print statistics
        // # extractWords,countWords,getMostFrequentWords,total
        System.out.printf(
                "%s,%.3f,%.3f,%.3f,%.3f%n",
                calculator.getClass().getSimpleName(),
                totalStopWatch.getElapsedTimeSeconds(),
                extractWordsStopWatch.getElapsedTimeSeconds(),
                countWordsStopWatch.getElapsedTimeSeconds(),
                wordFrequenciesStopWatch.getElapsedTimeSeconds()
        );

        // Perform cleanup
        words.clear();
        countWords.clear();
        wordFrequencies.clear();
    }
}
