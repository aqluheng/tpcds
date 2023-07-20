#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
GLUTEN_ENABLE=true
DATASET="parquet_10"
testJar="gluten-opensource-1.0.0" 
OUTFILE="tmp/${testJar}_test1.log"
source utils/helper-functions.sh

echo "-----------开始查询-----------"

setJarLink $testJar
$CMD -f warmQuery23.sql  &> tmp/${testJar}_test1.log
# $CMD -f warmSkip72.sql  &> tmp/${testJar}_test2.log
# $CMD -f warmSkip72.sql  &> tmp/${testJar}_test3.log
cat $OUTFILE | grep "Time taken:" | awk -F 'Time taken:' '{print $2}' | awk -F ' ' '{print $1}'
exit 0
