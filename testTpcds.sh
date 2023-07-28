#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`

GLUTEN_ENABLE=true
DATASET="parquet_1000"
testJar="yitian-master"
source utils/helper-functions.sh
setJarLink $testJar
cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test1.log
cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test2.log
cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test3.log


GLUTEN_ENABLE=true
DATASET="parquet_1000"
testJar="gluten-opensource-1.0.0"
source utils/helper-functions.sh
setJarLink $testJar
cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test1.log
cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test2.log
cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_gluten_test3.log

# GLUTEN_ENABLE=false
# testJar="gluten-vanilla"
# source utils/helper-functions.sh
# cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_vanilla_test1.log
# cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_vanilla_test2.log
# cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_vanilla_test3.log