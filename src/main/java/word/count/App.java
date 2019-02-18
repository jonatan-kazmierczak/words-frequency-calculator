package word.count;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class App {
    public static void main(String[] args) throws Exception {
        if ( args.length < 2 ) {
            String usage = String.format(
                    "Required parameters:%n" +
                            "\tclass_name: one of %s%n" +
                            "\tpath: path to text file%n%n",
                    Arrays.asList(
                            CounterJ02.class,
                            CounterJ05.class,
                            CounterJ07.class,
                            CounterJ08.class,
                            CounterJ08Parallel.class,
                            CounterJ11.class
                    )
            );
            System.out.println(usage);
            throw new AssertionError( "Missing class_name and/or path" );
        }

        Counter counter = (Counter) Class.forName( args[0] ).getDeclaredConstructor().newInstance();
        String path = args[1];
        run( counter, path );
    }

    private static void run(Counter counter, String path) {
        StopWatch totalStopWatch = new StopWatch();

        StopWatch extractWordsStopWatch = new StopWatch();
        List<String> words = counter.extractWords( path );
        extractWordsStopWatch.stop();

        StopWatch countWordsStopWatch = new StopWatch();
        Map<String, ? extends Number> countWords = counter.countWords( words );
        countWordsStopWatch.stop();

        StopWatch wordFrequenciesStopWatch = new StopWatch();
        List<WordFrequency> wordFrequencies = counter.mostFrequentWords( countWords, 15 );
        wordFrequenciesStopWatch.stop();

        totalStopWatch.stop();

        // Print word frequencies
        for (WordFrequency wordFrequency : wordFrequencies) {
            System.out.println( wordFrequency );
        }

        // Print statistics
        // # extractWords,countWords,mostFrequentWords,total
        System.out.printf(
                "%f,%f,%f,%f",
                extractWordsStopWatch.getElapsedTimeSeconds(),
                countWordsStopWatch.getElapsedTimeSeconds(),
                wordFrequenciesStopWatch.getElapsedTimeSeconds(),
                totalStopWatch.getElapsedTimeSeconds()
        );

        // Perform cleanup
        words.clear();
        countWords.clear();
        wordFrequencies.clear();
    }
}
