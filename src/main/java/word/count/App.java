package word.count;

import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class App {
    public static void main(String[] args) throws Exception {
        // Explicit instantiation required by native-image compiler (from GraalVM)
        Map<String, Counter> implementations = Stream.of(
                new CounterJ02(),
                new CounterJ05(),
                new CounterJ07(),
                new CounterJ08(),
                new CounterJ08Parallel()
        ).collect( Collectors.toMap( c -> c.getClass().getSimpleName(), c -> c, (l, r) -> l, TreeMap::new ) );

        if ( args.length < 2 || !implementations.containsKey( args[0] ) ) {
            String usage = String.format(
                    "Required parameters:%n" +
                            "\tclass_name: one of %s%n" +
                            "\tpath: path to text file%n%n",
                    implementations.keySet()
            );
            System.out.println(usage);
            throw new AssertionError( "Missing class_name and/or path" );
        }

        Counter counter = implementations.get( args[0] );
        String path = args[1];
        boolean beQuiet = args.length > 2;
        run( counter, path, beQuiet );
    }

    private static void run(Counter counter, String path, boolean beQuiet) {
        StopWatch totalStopWatch = new StopWatch();

        StopWatch extractWordsStopWatch = new StopWatch();
        List<String> words = counter.extractWords( path );
        int totalWordCount = words.size();
        extractWordsStopWatch.stop();

        StopWatch countWordsStopWatch = new StopWatch();
        Map<String, ? extends Number> countWords = counter.countWords( words );
        int uniqueWordCount = countWords.size();
        countWordsStopWatch.stop();

        StopWatch wordFrequenciesStopWatch = new StopWatch();
        List<WordFrequency> wordFrequencies = counter.mostFrequentWords( countWords, totalWordCount, 15 );
        wordFrequenciesStopWatch.stop();

        totalStopWatch.stop();

        if (!beQuiet) {
            System.out.printf( "%d total words %n%d unique words%n%n", totalWordCount, uniqueWordCount );
            // Print word frequencies
            for (WordFrequency wordFrequency : wordFrequencies) {
                System.out.println( wordFrequency );
            }
        }

        // Print statistics
        // # extractWords,countWords,mostFrequentWords,total
        System.out.printf(
                "%s,%.3f,%.3f,%.3f,%.3f%n",
                counter.getClass().getSimpleName(),
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
