#!/bin/bash
#
# Author: Jonatan Kazmierczak (Jonatan at Son-of-God.info)
#

# define variables
STATS_DIR=stats
TEXT_FILE=texts/bible_ylt.txt
#TEXT_FILE=texts/4_gospels.txt
JAVA_CMD=java

echo "-- Java Performance Statistics Collector --"
echo "Please make sure, that you are not running it in virtualized environment (i.e. Docker) and that your laptop works in performance mode"
echo

$JAVA_CMD -version
echo

echo "execution of Java bytecode with JIT−compiled code (Tier 3 / C1)"
REPEAT_COUNT=11
./run_x_times.sh $REPEAT_COUNT $JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ2 $TEXT_FILE 1 > $STATS_DIR/j2.csv
./run_x_times.sh $REPEAT_COUNT $JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ5 $TEXT_FILE 1 > $STATS_DIR/j5.csv
./run_x_times.sh $REPEAT_COUNT $JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ7 $TEXT_FILE 1 > $STATS_DIR/j7.csv
./run_x_times.sh $REPEAT_COUNT $JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE 1 > $STATS_DIR/j8.csv
./run_x_times.sh $REPEAT_COUNT $JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ8Prl $TEXT_FILE 1 > $STATS_DIR/j8prl.csv

echo "execution of Java bytecode with JIT−compiled code (Tier 3+4 / C1+C2)"
REPEAT_COUNT=51
$JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ2 $TEXT_FILE $REPEAT_COUNT > $STATS_DIR/j2jit.csv
$JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ5 $TEXT_FILE $REPEAT_COUNT > $STATS_DIR/j5jit.csv
$JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ7 $TEXT_FILE $REPEAT_COUNT > $STATS_DIR/j7jit.csv
$JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT > $STATS_DIR/j8jit.csv
$JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ8Prl $TEXT_FILE $REPEAT_COUNT > $STATS_DIR/j8prljit.csv

echo "execution of Java bytecode with JIT−compiled code (Tier 3+4 / C1+Graal)"
REPEAT_COUNT=201
$JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler -jar build/libs/words-freq-calc.jar CalculatorJ2 $TEXT_FILE $REPEAT_COUNT > $STATS_DIR/j2graal.csv
$JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler -jar build/libs/words-freq-calc.jar CalculatorJ5 $TEXT_FILE $REPEAT_COUNT > $STATS_DIR/j5graal.csv
$JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler -jar build/libs/words-freq-calc.jar CalculatorJ7 $TEXT_FILE $REPEAT_COUNT > $STATS_DIR/j7graal.csv
$JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT > $STATS_DIR/j8graal.csv
$JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler -jar build/libs/words-freq-calc.jar CalculatorJ8Prl $TEXT_FILE $REPEAT_COUNT > $STATS_DIR/j8prlgraal.csv

echo "execution of AOT−compiled code (GraalVM)"
REPEAT_COUNT=11
WFC=./words-freq-calc
./run_x_times.sh $REPEAT_COUNT $WFC CalculatorJ2 $TEXT_FILE 1 > $STATS_DIR/j2aot.csv
./run_x_times.sh $REPEAT_COUNT $WFC CalculatorJ5 $TEXT_FILE 1 > $STATS_DIR/j5aot.csv
./run_x_times.sh $REPEAT_COUNT $WFC CalculatorJ7 $TEXT_FILE 1 > $STATS_DIR/j7aot.csv
./run_x_times.sh $REPEAT_COUNT $WFC CalculatorJ8 $TEXT_FILE 1 > $STATS_DIR/j8aot.csv
./run_x_times.sh $REPEAT_COUNT $WFC CalculatorJ8Prl $TEXT_FILE 1 > $STATS_DIR/j8prlaot.csv

echo "execution of C++ compiled code"
REPEAT_COUNT=11
./run_x_times.sh $REPEAT_COUNT ./wfc $TEXT_FILE | grep CPP > $STATS_DIR/cpp.csv
