#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
source utils/helper-functions.sh
DATASET="parquet_db_1000_gluten"
# 配置是否使用Gluten与使用哪个Dataset
# getCMD 0 $DATASET
# cleanNodes && $CMD -f warmSkip72.sql  &> tmp/vanilla_test1.log
# cleanNodes && $CMD -f warmSkip72.sql  &> tmp/vanilla_test2.log
# cleanNodes && $CMD -f warmSkip72.sql  &> tmp/vanilla_test3.log

testJar="gluten-opensource-1.0" 
getCMD 1 $DATASET
setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test1.log
# setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test2.log
# setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test3.log

# testJar="gluten-opensource-insertForJoin" 
# sendToNodes $testJar
# getCMD 1 $DATASET
# setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test1.log
# setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test2.log
# setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test3.log