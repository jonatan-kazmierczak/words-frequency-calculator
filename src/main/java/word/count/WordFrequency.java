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

    @Override
    public String toString() {
        return "WordFrequency{" +
                "word='" + word + '\'' +
                ", count=" + count +
                ", totalCount=" + totalCount +
                '}';
    }
}
