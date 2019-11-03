## Java - choosing a Garbage Collector

### Considered Garbage Collectors in HotSpot VM
https://docs.oracle.com/en/java/javase/12/gctuning/

#### G1
* default GC since Java 9:  
  [Getting Started with the G1 Garbage Collector](https://www.oracle.com/technetwork/tutorials/tutorials-1876574.html)
* features added in Java 10:  
  [Parallel Full GC for G1](http://openjdk.java.net/jeps/307)
* features added in Java 12:
  * [Promptly Return Unused Committed Memory from G1](http://openjdk.java.net/jeps/346)  
  * [Abortable Mixed Collections for G1](http://openjdk.java.net/jeps/344)  
* use this GC: `-XX:+UseG1GC`
* use improved variant (since Java 12): `-XX:+UseG1GC -XX:G1PeriodicGCInterval=10000 -XX:G1PeriodicGCSystemLoadThreshold=100`

#### Parallel
* default GC in Java 8
* use this GC: `-XX:+UseParallelGC`

#### Serial
* use this GC: `-XX:+UseSerialGC`
* use improved variant (since Java 9): `-XX:+UseSerialGC -XX:-ShrinkHeapInSteps`

#### Z (Experimental)
* available since Java 11:  
  [ZGC: A Scalable Low-Latency Garbage Collector (Experimental)](http://openjdk.java.net/jeps/333)
* features added in Java 13:  
  [ZGC: Uncommit Unused Memory](http://openjdk.java.net/jeps/351)
* use this GC: `-XX:+UnlockExperimentalVMOptions -XX:+UseZGC`
* use improved variant (since Java 13): `-XX:+UnlockExperimentalVMOptions -XX:+UseZGC -XX:ZUncommitDelay=1`

#### Shenandoah (Experimental)
* available since Java 12 in non-Oracle builds (i.e. AdoptOpenJDK), available since Java 8 in RedHat builds:  
  [Shenandoah: A Low-Pause-Time Garbage Collector (Experimental)](http://openjdk.java.net/jeps/189)
* use this GC: `-XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC`
* use improved variant: `-XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -XX:ShenandoahUncommitDelay=1000 -XX:ShenandoahGuaranteedGCInterval=10000`

#### Epsilon (Experimental)
* available since Java 11:  
  [Epsilon: A No-Op Garbage Collector (Experimental)](http://openjdk.java.net/jeps/318)
* use this GC: `-XX:+UnlockExperimentalVMOptions -XX:+UseEpsilonGC`

### Considered Garbage Collectors in OpenJ9 VM
https://developer.ibm.com/articles/garbage-collection-tradeoffs-and-tuning-with-openj9/

#### gencon
Default GC.
