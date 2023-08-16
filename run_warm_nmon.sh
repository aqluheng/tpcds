#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
GLUTEN_ENABLE=true
DATASET="parquet_1000"
OUTFILE="tmp/time_nmon.log"
source utils/helper-functions.sh

echo "-----------开始查询-----------"
setJarLink gluten-opensource-1.0.0 && cleanNodes
pkill -f client_generate_nmon.py
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo pkill -f nmon
python client_generate_nmon.py &
$CMD -f warmSkip72.sql  &> $OUTFILE
exit 0
