package word.count;

public final class WordFrequency {
    public final String word;
    public final int count;
    public final int totalCount;

    public WordFrequency(String word, int count, int totalCount) {
        this.word = word;
        this.count = count;
        this.totalCount = totalCount;
    }

    public double getFrequency() {
        return 1.0 * count / totalCount;
    }

    @Override
    public String toString() {
        return "WordFrequency{" +
                " frequency=" + String.format( "%.3f", getFrequency() ) +
                ", count=" + count +
                ", word='" + word + '\'' +
                " }";
    }
}
