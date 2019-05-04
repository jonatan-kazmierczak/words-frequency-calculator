#include <string>
#include <chrono>
#include <vector>
#include <map>
#include <unordered_map>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <cmath>
#include <boost/algorithm/string.hpp>

using namespace std;

class StopWatch {
    chrono::time_point<chrono::steady_clock> start, end;
public:
    StopWatch() {
        start = chrono::steady_clock::now();
    }
    
    void stop() {
        end = chrono::steady_clock::now();
    }
    
    int getElapsedTimeMs() {
        return round( getElapsedTimeSeconds() * 1000 );
    }
    
    double getElapsedTimeSeconds() {
        chrono::duration<double> elapsed_seconds = end - start;
        return elapsed_seconds.count();
    }
};


struct WordFrequency {
    string word;
    int count;
    int totalCount;
    
    double getFrequency() {
        return 1.0 * count / totalCount;
    }
};


const int WORD_LENGTH_THRESHOLD = 0;

inline vector<string> extractWords(string path) {
    vector<string> words;
    words.reserve( 0x1000 );
    ifstream fin(path);

    while ( !fin.eof() ) {
        string word;
        fin >> word;
        if ( word.length() > WORD_LENGTH_THRESHOLD ) {
            boost::to_lower( word );
            words.push_back( word );
        }
    }
    return words;
}

inline unordered_map<string, int> countWords(vector<string>& words) {
    unordered_map<string, int> wordCounters;
    for (auto word : words) {
        ++wordCounters[ word ];
    }
    return wordCounters;
}

inline vector<WordFrequency> mostFrequentWords(unordered_map<string, int>& wordCountsMap, int totalCount, int limit) {
    vector<pair<string, int>> wordCounts( wordCountsMap.begin(), wordCountsMap.end() );
    sort( wordCounts.begin(), wordCounts.end(),
            [](auto& a, auto& b) -> auto { return b.second < a.second; }
    );
    vector<WordFrequency> wordFrequencies;
    wordFrequencies.reserve( limit );
    for (int i = 0; i < min( (int) wordCounts.size(), limit ); ++i) {
        wordFrequencies.push_back( { wordCounts[i].first, wordCounts[i].second, totalCount } );
    }
    return wordFrequencies;
}


inline void run(string& path) {
    StopWatch totalStopWatch;
    
    StopWatch extractWordsStopWatch;
    auto words = extractWords( path );
    int totalWordCount = words.size();
    extractWordsStopWatch.stop();

    StopWatch countWordsStopWatch;
    auto countWordsMap = countWords( words );
    int uniqueWordCount = countWordsMap.size();
    countWordsStopWatch.stop();

    StopWatch wordFrequenciesStopWatch;
    auto wordFrequencies = mostFrequentWords( countWordsMap, totalWordCount, 15 );
    wordFrequenciesStopWatch.stop();

    totalStopWatch.stop();

    printf( "%d considered words \n%d unique words\n\n", totalWordCount, uniqueWordCount );
    for (auto wordFrequency : wordFrequencies) {
        printf( "WordFrequency{ frequency=%.3f, count=%d, word='%s' }\n",
                wordFrequency.getFrequency(), wordFrequency.count, wordFrequency.word.c_str() );
    }

    // Print statistics
    printf(
            "CPP,%d,%d,%d,%d\n",
            totalStopWatch.getElapsedTimeMs(),
            extractWordsStopWatch.getElapsedTimeMs(),
            countWordsStopWatch.getElapsedTimeMs(),
            wordFrequenciesStopWatch.getElapsedTimeMs()
    );
}

int main(int argc, char** argv) {
    if ( argc < 2 ) {
        cerr << "Missing path" << endl;
        return 1;
    }
    string path = argv[1];
    run( path );
    
    return 0;
}

// g++ -std=c++14 -O2 -o wc word_counter.cpp
// clang++ -std=c++14 -O2 -o wc1 word_counter.cpp
