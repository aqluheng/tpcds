#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
OUTFILE="tmp/time_nmon.log"
source utils/helper-functions.sh

DATASET="parquet_db_3000_gluten"
getCMD 1 $DATASET

echo "-----------开始查询-----------"
setJarLink gluten-opensource-1.0 && cleanNodes
pkill -f client_generate_nmon.py
sudo -u root ssh -o StrictHostKeyChecking=no node1 sudo pkill -f nmon
python client_generate_nmon.py &
$CMD -f warmSkip72.sql  &> $OUTFILE
exit 0
