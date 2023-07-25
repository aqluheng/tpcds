#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
# 配置是否使用Gluten与使用哪个Dataset
GLUTEN_ENABLE=true
DATASET="parquet_1000"
source utils/helper-functions.sh

testJar="gluten-unflat-insertForJoin" 
setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test1.log
setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test2.log
setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test3.log

testJar="gluten-opensource-1.0.0" 
setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test1.log
setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test2.log
setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test3.log
