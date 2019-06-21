#!/bin/bash
#
# Author: Jonatan Kazmierczak (Jonatan at Son-of-God.info)
#

# define variables
STATS_DIR=stats
TEXT_FILE=texts/bible_ylt.txt
#TEXT_FILE=texts/4_gospels.txt
# Path to java command from OpenJDK build including Shenandoah GC - i.e. AdoptOpenJDK
JAVA_CMD=java
# Path to java command from OpenJDK with OpenJ9 VM
JAVA_J9_CMD=/opt2/jdk-12.0.1+12_j9/bin/java
REPEAT_COUNT=11

echo "-- Java GC Performance Statistics Collector --"
echo "Please make sure, that you are not running it in virtualized environment (i.e. Docker) and that your laptop works in performance mode"
echo

$JAVA_CMD -version
echo

echo "Single-thread version"
OUT_FILE=$STATS_DIR/gc.txt

echo -n gc=Epsilon, > $OUT_FILE
/bin/time $JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseEpsilonGC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n gc=G1, >> $OUT_FILE
/bin/time $JAVA_CMD -XX:+UseG1GC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT  2>>$OUT_FILE

echo -n gc=Parallel, >> $OUT_FILE
/bin/time $JAVA_CMD -XX:+UseParallelGC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT  2>>$OUT_FILE

echo -n gc=Serial, >> $OUT_FILE
/bin/time $JAVA_CMD -XX:+UseSerialGC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT  2>>$OUT_FILE

echo -n gc=Z, >> $OUT_FILE
/bin/time $JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseZGC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n gc=Shenandoah, >> $OUT_FILE
/bin/time $JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n gc=gencon, >> $OUT_FILE
/bin/time $JAVA_J9_CMD -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n gc=SVM, >> $OUT_FILE
/bin/time ./words-freq-calc CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE


echo
echo "Parallel version"
OUT_FILE=$STATS_DIR/gc_prl.txt

echo -n gc=Epsilon, > $OUT_FILE
/bin/time $JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseEpsilonGC -jar build/libs/words-freq-calc.jar CalculatorJ8Prl $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n gc=G1, >> $OUT_FILE
/bin/time $JAVA_CMD -XX:+UseG1GC -jar build/libs/words-freq-calc.jar CalculatorJ8Prl $TEXT_FILE $REPEAT_COUNT  2>>$OUT_FILE

echo -n gc=Parallel, >> $OUT_FILE
/bin/time $JAVA_CMD -XX:+UseParallelGC -jar build/libs/words-freq-calc.jar CalculatorJ8Prl $TEXT_FILE $REPEAT_COUNT  2>>$OUT_FILE

echo -n gc=Serial, >> $OUT_FILE
/bin/time $JAVA_CMD -XX:+UseSerialGC -jar build/libs/words-freq-calc.jar CalculatorJ8Prl $TEXT_FILE $REPEAT_COUNT  2>>$OUT_FILE

echo -n gc=Z, >> $OUT_FILE
/bin/time $JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseZGC -jar build/libs/words-freq-calc.jar CalculatorJ8Prl $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n gc=Shenandoah, >> $OUT_FILE
/bin/time $JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -jar build/libs/words-freq-calc.jar CalculatorJ8Prl $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n gc=gencon, >> $OUT_FILE
/bin/time $JAVA_J9_CMD -jar build/libs/words-freq-calc.jar CalculatorJ8Prl $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE
