#!/bin/bash
#
# Author: Jonatan Kazmierczak (Jonatan at Son-of-God.info)
#

# define variables
STATS_DIR=stats
TEXT_FILE=texts/bible_ylt.txt
#TEXT_FILE=texts/4_gospels.txt
# Path to java command from OpenJDK build including Shenandoah GC - i.e. AdoptOpenJDK
JAVA_CMD=/opt2/jdk-13.0.1+9/bin/java
# Path to java command from OpenJDK with OpenJ9 VM
JAVA_J9_CMD=/opt2/jdk-13.0.1+9_openj9/bin/java
# Path to java command from Zing VM
JAVA_ZING_CMD=/opt2/zing-jdk11.0.0-19.10.1.0-3/bin/java

REPEAT_COUNT=11

echo "-- Java GC Performance Statistics Collector --"
echo "Please make sure, that you are not running it in virtualized environment (i.e. Docker) and that your CPU runs on a constant frequency"
echo

$JAVA_CMD -version
echo

echo "Single-thread version"
OUT_FILE=$STATS_DIR/gc.txt

# HotSpot

echo -n vm=HotSpot,gc=Epsilon, > $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseEpsilonGC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n vm=HotSpot,gc=Serial, >> $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UseSerialGC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT  2>>$OUT_FILE

echo -n vm=HotSpot,gc=Parallel, >> $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UseParallelGC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT  2>>$OUT_FILE

echo -n vm=HotSpot,gc=G1, >> $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UseG1GC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT  2>>$OUT_FILE

echo -n vm=HotSpot,gc=Z, >> $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseZGC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n vm=HotSpot,gc=Shenandoah, >> $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

# OpenJ9

echo -n vm=OpenJ9,gc=nogc, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:nogc -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n vm=OpenJ9,gc=gencon, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:gencon -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n vm=OpenJ9,gc=balanced, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:balanced -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n vm=OpenJ9,gc=optavgpause, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:optavgpause -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n vm=OpenJ9,gc=optthruput, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:optthruput -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

echo -n vm=OpenJ9,gc=metronome, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:metronome -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

# Zing

echo -n vm=Zing,gc=C4, >> $OUT_FILE
/usr/bin/time $JAVA_ZING_CMD -jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE

# SVM

echo -n vm=Substrate,gc=SVM, >> $OUT_FILE
/usr/bin/time ./words-freq-calc CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE
