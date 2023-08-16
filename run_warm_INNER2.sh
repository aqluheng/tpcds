#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
source utils/helper-functions.sh
DATASET="parquet_1000"
# 配置是否使用Gluten与使用哪个Dataset
# getCMD 0 $DATASET
# cleanNodes && $CMD -f warmSkip72.sql  &> tmp/vanilla_test1.log

testJar="gluten-opensource-1.0.0" 
getCMD 1 $DATASET
setJarLink $testJar && cleanNodes && $CMD -f warmInner2.sql  &> tmp/${testJar}_test1.log


testJar="gluten-1.0.0-onlyLinear" 
getCMD 1 $DATASET
setJarLink $testJar && cleanNodes && $CMD -f warmInner2.sql  &> tmp/${testJar}_test1.log