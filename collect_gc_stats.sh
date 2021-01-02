#!/bin/bash
#
# Author: Jonatan Kazmierczak (Jonatan at Son-of-God.info)
#

# define variables
STATS_DIR=stats
TEXT_FILE=texts/bible_ylt.txt
REPEAT_COUNT=21
JAVA_APP="-jar build/libs/words-freq-calc.jar CalculatorJ8 $TEXT_FILE $REPEAT_COUNT"
# Path to java command from OpenJDK build
JAVA_CMD=/opt2/jdk-15.0.1+9_hotspot/bin/java
# Path to java command from OpenJDK with OpenJ9 VM
JAVA_J9_CMD=/opt2/jdk-15.0.1+9_openj9/bin/java
# Path to java command from Zing VM
JAVA_ZING_CMD=/opt2/zing20.12.0.0-5-ca-jdk11.0.9-linux_x64/bin/java
# Path to java command from GraalVM
JAVA_GRAALVM_CMD=/opt2/graalvm-ce-java11-20.3.0/bin/java

echo "-- Java GC Performance Statistics Collector --"
echo "Please make sure, that you are not running it in virtualized environment (i.e. Docker) and that your CPU runs on a constant frequency"
echo

$JAVA_CMD -version
echo

echo "Single-thread version"
OUT_FILE=$STATS_DIR/gc.txt

# HotSpot

echo -n vm=HotSpot,gc=Epsilon, > $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UnlockExperimentalVMOptions -XX:+UseEpsilonGC $JAVA_APP 2>>$OUT_FILE

echo -n vm=HotSpot,gc=Serial, >> $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UseSerialGC $JAVA_APP 2>>$OUT_FILE

echo -n vm=HotSpot,gc=Parallel, >> $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UseParallelGC $JAVA_APP 2>>$OUT_FILE

echo -n vm=HotSpot,gc=G1, >> $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UseG1GC $JAVA_APP 2>>$OUT_FILE

echo -n vm=HotSpot,gc=Z, >> $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UseZGC $JAVA_APP 2>>$OUT_FILE

echo -n vm=HotSpot,gc=Shenandoah, >> $OUT_FILE
/usr/bin/time $JAVA_CMD -XX:+UseShenandoahGC $JAVA_APP 2>>$OUT_FILE

# OpenJ9

echo -n vm=OpenJ9,gc=nogc, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:nogc $JAVA_APP 2>>$OUT_FILE

echo -n vm=OpenJ9,gc=gencon, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:gencon $JAVA_APP 2>>$OUT_FILE

echo -n vm=OpenJ9,gc=balanced, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:balanced $JAVA_APP 2>>$OUT_FILE

echo -n vm=OpenJ9,gc=optavgpause, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:optavgpause $JAVA_APP 2>>$OUT_FILE

echo -n vm=OpenJ9,gc=optthruput, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:optthruput $JAVA_APP 2>>$OUT_FILE

echo -n vm=OpenJ9,gc=metronome, >> $OUT_FILE
/usr/bin/time $JAVA_J9_CMD -Xgcpolicy:metronome $JAVA_APP 2>>$OUT_FILE

# Zing
echo -n vm=Zing,gc=C4, >> $OUT_FILE
/usr/bin/time $JAVA_ZING_CMD $JAVA_APP 2>>$OUT_FILE

# GraalVM
echo -n vm=GraalVM,gc=G1, >> $OUT_FILE
/usr/bin/time $JAVA_GRAALVM_CMD $JAVA_APP 2>>$OUT_FILE

# Substrate
echo -n vm=Substrate,gc=none, >> $OUT_FILE
/usr/bin/time ./words-freq-calc CalculatorJ8 $TEXT_FILE $REPEAT_COUNT 2>>$OUT_FILE
