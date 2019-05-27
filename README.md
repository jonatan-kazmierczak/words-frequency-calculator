# Words Frequency Calculator
Simple application calculating most frequent words in a given text file,
demonstrating features of Java and C++
and allowing to collect various statistics

## Java application
It contains implementations using the following versions of the Java standard library:
- CalculatorJ2 - v1.2
- CalculatorJ5 - v1.5
- CalculatorJ7 - v1.7
- CalculatorJ8 - v1.8
- CalculatorJ8Prl - v1.8, parallel variant

### Build a JAR file
If you have Gradle installed, then
```bash
gradle build
```

Otherwise
```bash
./gradlew build
```

### Run a JAR file

#### Show usage
```bash
java -jar build/libs/words-freq-calc.jar
```

#### Run one implementation
calculating word frequencies in a given file.

##### Single processing
* shows results
* shows time statistics in CSV format (with header)
* executes Java bytecode with JIT−compiled code (Tier 3 / C1).  

```bash
java -jar build/libs/words-freq-calc.jar CalculatorJ8 texts/bible_ylt.txt
```

##### Multiple processings
* executes the processing several times
* shows time statistics in CSV format (without header) - for further analysis
* few first processings execute Java bytecode with JIT−compiled code (Tier 3 / C1)
* few next processings execute some Java bytecode with mainly JIT−compiled code (Tier 3+4 / C1+C2)
* following processings demonstrate the peak performance of the JIT-compiled code

```bash
java -jar build/libs/words-freq-calc.jar CalculatorJ8 texts/bible_ylt.txt 11
```

* many processings allow to monitor performance of the code and resources consumption

```bash
java -jar build/libs/words-freq-calc.jar CalculatorJ8 texts/bible_ylt.txt 1000
```

### Build an executable
This demonstrates AOT compilation using [GraalVM](https://graalvm.org) (on Linux and OSX).

Once GraalVM is installed:
```bash
$GRAALVM_HOME/bin/native-image -jar build/libs/words-freq-calc.jar
```

### Run an executable

#### Show usage
```bash
./words-freq-calc
```

#### Run one implementation
calculating word frequencies in a given file.

##### Single processing
* shows results
* shows time statistics in CSV format (with header)
* executes AOT−compiled code

```bash
./words-freq-calc CalculatorJ8 texts/bible_ylt.txt
```

##### Multiple processings
* executes the processing several times
* shows time statistics in CSV format (without header) - for further analysis
* processings execute the same AOT-compiled code

```bash
./words-freq-calc CalculatorJ8 texts/bible_ylt.txt 11
```

* many processings allow to monitor performance of the code and resources consumption

```bash
./words-freq-calc CalculatorJ8 texts/bible_ylt.txt 1000
```


## C++ implementation

### Build an executable

#### Using clang
modern compiler and linker
```bash
clang++ -std=c++14 -O2 -o wfc src/main/cpp/words-freq-calc.cpp
```

#### Using gcc
traditional compiler and linker
```bash
g++ -std=c++14 -O2 -o wfc src/main/cpp/words-freq-calc.cpp
```

### Run an executable

#### Show usage
```bash
./wfc
```

#### Run the implementation
calculating word frequencies in a given file.

* shows results
* shows time statistics in CSV format (with header)
* executes compiled code

```bash
./wfc texts/bible_ylt.txt
```

## Collect extensive performance statistics
in CSV files in `stats` directory
```bash
./collect_statistics.sh
```

Please take a look at the script to see, what statistics are collected and how.  
Feel free to adapt the script to your needs.

## Analyze collected performance statistics
in text format, as well as on charts - using R scripts in `stats` directory
```bash
Rscript show_stats.R
Rscript show_stats_charts.R
```
