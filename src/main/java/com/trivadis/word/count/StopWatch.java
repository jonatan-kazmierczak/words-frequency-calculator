package com.trivadis.word.count;

public final class StopWatch {
    private final long startTime = System.currentTimeMillis();
    private long endTime;

    public void stop() {
        endTime = System.currentTimeMillis();
    }

    public int getElapsedTimeMs() {
        return (int)( endTime - startTime );
    }

    public double getElapsedTimeSeconds() {
        return ( endTime - startTime ) / 1000.0;
    }
}
