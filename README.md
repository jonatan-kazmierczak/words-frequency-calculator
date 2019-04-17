# Words Frequency Calculator
Simple application calculating most frequent words in a given text file,
demonstrating features of Java and C++

## Java application

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
calculating word frequencies in a given file
```bash
java -jar build/libs/words-freq-calc.jar CalculatorJ8 big_example-4_gospels.txt
```

#### Run multiple times
to collect performance statistics
```bash
./run_x_times.sh 11 java -jar build/libs/words-freq-calc.jar CalculatorJ8 big_example-4_gospels.txt q
```

### Build an executable
on OSX or Linux.  
You will need a [GraalVM](https://graalvm.org) package.

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
calculating word frequencies in a given file
```bash
./words-freq-calc CalculatorJ8 big_example-4_gospels.txt
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

#### Run implementation
calculating word frequencies in a given file
```bash
./wfc big_example-4_gospels.txt
```
