#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
source utils/helper-functions.sh

GLUTEN_ENABLE=true
DATASET="parquet_1000"
OUTFILE="tmp/time_split.log"

glutencmd="spark-sql --master yarn \
          --deploy-mode client \
            --conf spark.driver.cores=8 \
              --conf spark.driver.memory=20g \
                --conf spark.executor.instances=20 \
                  --conf spark.executor.cores=8 \
                    --conf spark.executor.memory=10G \
                      --conf spark.plugins=io.glutenproject.GlutenPlugin \
                        --conf spark.gluten.sql.columnar.backend.lib=velox \
                          --conf spark.executorEnv.VELOX_HDFS="hdfs://master-1-1:9000" \
                            --conf spark.shuffle.manager=org.apache.spark.shuffle.sort.ColumnarShuffleManager \
                              --conf spark.memory.offHeap.enabled=true \
                                --conf spark.memory.offHeap.size=10g \
                                  --conf spark.executor.memoryOverhead=1g \
                                    --conf spark.driver.maxResultSize=32g \
                                    --conf spark.gluten.loadLibFromJar=true \
                                    --conf spark.gluten.enabled=${GLUTEN_ENABLE} \
                                    --conf spark.gluten.sql.debug=true \
                                    --conf spark.gluten.sql.benchmark_task.stageId=10 \
                                    --conf spark.gluten.sql.benchmark_task.partitionId=-1 \
                                    --conf spark.gluten.sql.benchmark_task.taskId=-1 \
                                    --conf spark.gluten.saveDir=/tmp/save/ \
                                    --conf spark.executor.extraClassPath="/opt/apps/METASTORE/metastore-current/hive2/*:/opt/apps/JINDOSDK/jindosdk-current/lib/*:/opt/apps/EMRHOOK/emrhook-current/spark-hook-spark30.jar:/opt/apps/SPARK3/gluten-current/*"\
                                    --conf spark.driver.extraClassPath="/opt/apps/METASTORE/metastore-current/hive2/*:/opt/apps/JINDOSDK/jindosdk-current/lib/*:/opt/apps/EMRHOOK/emrhook-current/spark-hook-spark30.jar:/opt/apps/SPARK3/gluten-current/*"\
                                   --database $DATASET"
CMD=$glutencmd    

echo "-----------开始查询-----------"
echo "-----------开始查询-----------" > $OUTFILE

# 将gluten-current指向编译好的jar包路径
setJarLink debug-2023-07-01

#exec sql
for (( i=23;i<=23;++i ))
do
    case $i in
      72|95)
        continue
        ;;
      *)
        ;;
    esac
    echo "query$i start"
    $CMD -f "qualification-queries/query${i}a.sql"  &>> $OUTFILE
done
exit 0
