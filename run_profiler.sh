#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`

GLUTEN_ENABLE=true
DATASET="parquet_1000"
OUTFILE="tmp/time_profiler.log"
source utils/helper-functions.sh

echo "-----------开始查询-----------" | tee $OUTFILE
setJarLink gluten-2023-07-01

cleanNodes
for (( i=95;i<=95;++i ))
do
    # case $i in
    #   72|95)
    #     continue
    #     ;;
    # esac
    echo "query$i start"
    # sed -i 's/{{APP_ID}}_{{EXECUTOR_ID}}.*$/{{APP_ID}}_{{EXECUTOR_ID}}_'$i'.html/' spark-conf/spark-defaults.conf
    $CMD -f "qualification-queries/query$i.sql"  &>> $OUTFILE
done
cat $OUTFILE | grep "Time taken:" | awk -F 'Time taken:' '{print $2}' | awk -F ' ' '{print $1}'
exit 0