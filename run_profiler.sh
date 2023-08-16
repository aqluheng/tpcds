#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
source utils/helper-functions.sh

GLUTEN_ENABLE=true
DATASET="parquet_db_1000"
getCMD 1 $DATASET

OUTFILE="tmp/time_profiler.log"

echo "-----------开始查询-----------" | tee $OUTFILE
setJarLink opensource-1.0

cleanNodes
for (( i=44;i<=44;++i ))
do
    case $i in
      4|23|24|44)
        ;;
      *)
        continue
        ;;
    esac
    echo "query$i start"
    sed -i 's/{{APP_ID}}_{{EXECUTOR_ID}}.*$/{{APP_ID}}_{{EXECUTOR_ID}}_'$i'.html/' spark-conf/spark-defaults.conf
    $CMD -f "qualification-queries/query$i.sql"  &>> $OUTFILE
done
cat $OUTFILE | grep "Time taken:" | awk -F 'Time taken:' '{print $2}' | awk -F ' ' '{print $1}'
exit 0