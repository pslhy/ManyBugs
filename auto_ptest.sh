#! /bin/bash
# auto run with test.sh
# $1 : max number of p test
# if max p is p7500,  ./auto_ptest.sh 7500

max=$1

for ((i=1;i<=$max;i++))
do

    echo "Running loop p"$i
    ./test.sh p$i

done