#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
GLUTEN_ENABLE=true
DATASET="parquet_1000"
OUTFILE="tmp/time_profiler.log"
source utils/helper-functions.sh

echo "-----------开始查询-----------"
setJarLink gluten-2023-07-01
pkill -f client_generate_nmon.py
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo pkill -f nmon
python client_generate_nmon.py &
cleanNodes && $CMD -f warmSkip72.sql  &> $OUTFILE
exit 0
