#!/bin/bash
#
# Author: Jonatan Kazmierczak (Jonatan at Son-of-God.info)
#

# prepare dir for stats
STATS_DIR=stats
mkdir -p $STATS_DIR

# Java command
JAVA_CMD=java

echo "-- Java Performance Statistics Collector --"
echo "Note: Please switch your laptop to performance mode before using it"
echo

$JAVA_CMD -version
echo

echo "execution of Java bytecode with JIT−compiled code (Tier 3 / C1)"
REPEAT_COUNT=11
./run_x_times.sh $REPEAT_COUNT $JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ2 big_example-4_gospels.txt 1 > $STATS_DIR/j2.csv
./run_x_times.sh $REPEAT_COUNT $JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ5 big_example-4_gospels.txt 1 > $STATS_DIR/j5.csv
./run_x_times.sh $REPEAT_COUNT $JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ7 big_example-4_gospels.txt 1 > $STATS_DIR/j7.csv
./run_x_times.sh $REPEAT_COUNT $JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ8 big_example-4_gospels.txt 1 > $STATS_DIR/j8.csv
./run_x_times.sh $REPEAT_COUNT $JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ8Prl big_example-4_gospels.txt 1 > $STATS_DIR/j8prl.csv

echo "execution of Java bytecode with JIT−compiled code (Tier 3+4 / C1+C2)"
REPEAT_COUNT=51
$JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ2 big_example-4_gospels.txt $REPEAT_COUNT > $STATS_DIR/j2jit.csv
$JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ5 big_example-4_gospels.txt $REPEAT_COUNT > $STATS_DIR/j5jit.csv
$JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ7 big_example-4_gospels.txt $REPEAT_COUNT > $STATS_DIR/j7jit.csv
$JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ8 big_example-4_gospels.txt $REPEAT_COUNT > $STATS_DIR/j8jit.csv
$JAVA_CMD -jar build/libs/words-freq-calc.jar CalculatorJ8Prl big_example-4_gospels.txt $REPEAT_COUNT > $STATS_DIR/j8prljit.csv

echo "execution of Java bytecode with JIT−compiled code (Tier 3+4 / C1+Graal)"
REPEAT_COUNT=201
$JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler -jar build/libs/words-freq-calc.jar CalculatorJ2 big_example-4_gospels.txt $REPEAT_COUNT > $STATS_DIR/j2graal.csv
$JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler -jar build/libs/words-freq-calc.jar CalculatorJ5 big_example-4_gospels.txt $REPEAT_COUNT > $STATS_DIR/j5graal.csv
$JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler -jar build/libs/words-freq-calc.jar CalculatorJ7 big_example-4_gospels.txt $REPEAT_COUNT > $STATS_DIR/j7graal.csv
$JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler -jar build/libs/words-freq-calc.jar CalculatorJ8 big_example-4_gospels.txt $REPEAT_COUNT > $STATS_DIR/j8graal.csv
$JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseJVMCICompiler -jar build/libs/words-freq-calc.jar CalculatorJ8Prl big_example-4_gospels.txt $REPEAT_COUNT > $STATS_DIR/j8prlgraal.csv

echo "execution of AOT−compiled code (GraalVM)"
REPEAT_COUNT=11
WFC=./words-freq-calc
./run_x_times.sh $REPEAT_COUNT $WFC CalculatorJ2 big_example-4_gospels.txt 1 > $STATS_DIR/j2aot.csv
./run_x_times.sh $REPEAT_COUNT $WFC CalculatorJ5 big_example-4_gospels.txt 1 > $STATS_DIR/j5aot.csv
./run_x_times.sh $REPEAT_COUNT $WFC CalculatorJ7 big_example-4_gospels.txt 1 > $STATS_DIR/j7aot.csv
./run_x_times.sh $REPEAT_COUNT $WFC CalculatorJ8 big_example-4_gospels.txt 1 > $STATS_DIR/j8aot.csv
./run_x_times.sh $REPEAT_COUNT $WFC CalculatorJ8Prl big_example-4_gospels.txt 1 > $STATS_DIR/j8prlaot.csv

echo "execution of C++ compiled code"
REPEAT_COUNT=11
./run_x_times.sh $REPEAT_COUNT ./wfc big_example-4_gospels.txt | grep CPP > $STATS_DIR/cpp.csv
