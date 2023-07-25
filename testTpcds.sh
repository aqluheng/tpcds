#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`

GLUTEN_ENABLE=true
DATASET="parquet_1000"
testJar="yitian-useNEON"
source utils/helper-functions.sh
setJarLink $testJar
$CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test1.log
$CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test2.log
$CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test3.log


GLUTEN_ENABLE=true
DATASET="parquet_1000"
testJar="gluten-opensource-1.0.0"
source utils/helper-functions.sh
setJarLink $testJar
$CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test1.log
$CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test2.log
$CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test3.log

# GLUTEN_ENABLE=false
# testJar="gluten-vanilla"
# source utils/helper-functions.sh
# $CMD -f warmSkip72.sql  &> tmp/${testJar}_vanilla_test1.log
# $CMD -f warmSkip72.sql  &> tmp/${testJar}_vanilla_test2.log
# $CMD -f warmSkip72.sql  &> tmp/${testJar}_vanilla_test3.log



