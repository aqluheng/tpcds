#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
GLUTEN_ENABLE=false
DATASET="tpch_1000"
testJar="gluten-opensource-1.0.0"

source utils/helper-functions.sh
setJarLink $testJar
$CMD -f warmTpch.sql  &> tmp/tpch_${testJar}_vanilla_test1.log
$CMD -f warmTpch.sql  &> tmp/tpch_${testJar}_vanilla_test2.log
$CMD -f warmTpch.sql  &> tmp/tpch_${testJar}_vanilla_test3.log


GLUTEN_ENABLE=true
source utils/helper-functions.sh
$CMD -f warmTpch.sql  &> tmp/tpch_${testJar}_gluten_test1.log
$CMD -f warmTpch.sql  &> tmp/tpch_${testJar}_gluten_test2.log
$CMD -f warmTpch.sql  &> tmp/tpch_${testJar}_gluten_test3.log