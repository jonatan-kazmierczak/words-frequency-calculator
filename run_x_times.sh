#!/bin/bash

TIMES=$1

#echo "Execute '$TIMES' times"

if [ "$TIMES" == "" ]; then
    echo "Please provide number of times to repeat the given command"
    exit 1
fi

shift
#date +%s.%N
for (( i=0 ; $i < $TIMES ; i++ )); do
    $*
done
#date +%s.%N
