#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
GLUTEN_ENABLE=true
DATASET="parquet_1000"
OUTFILE="tmp/time_profiler.log"
source utils/helper-functions.sh

echo "-----------开始查询-----------"

runJar(){
  rm /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo rm /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo rm /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo rm /opt/apps/SPARK3/gluten-current
  ln -s /opt/apps/SPARK3/$testJar /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo ln -s /opt/apps/SPARK3/$testJar /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo ln -s /opt/apps/SPARK3/$testJar /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo ln -s /opt/apps/SPARK3/$testJar /opt/apps/SPARK3/gluten-current
  $CMD -f warmSkip72.sql  &> tmp/${testJar}_test1.log
}

testJar="gluten-2023-07-01" 
runJar


exit 0
