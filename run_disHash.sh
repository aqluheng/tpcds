#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`
# 配置是否使用Gluten与使用哪个Dataset
GLUTEN_ENABLE=false
DATASET="parquet_1000"
source utils/helper-functions.sh
cleanNodes && $CMD -f warmSkip72.sql  &> tmp/vanilla_test1.log

GLUTEN_ENABLE=true
source utils/helper-functions.sh
testJar="gluten-opensource-1.0.0" 
setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_test1.log



testJar="gluten-opensource-1.0.0" 
CMD="spark-sql --master yarn \
          --deploy-mode client \
            --conf spark.driver.cores=8 \
              --conf spark.driver.memory=20g \
                --conf spark.executor.instances=20 \
                --conf spark.gluten.sql.columnar.forceShuffledHashJoin=false \
                --conf spark.sql.join.preferSortMergeJoin=true \
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
                                    --conf spark.executor.extraClassPath="/opt/apps/METASTORE/metastore-current/hive2/*:/opt/apps/JINDOSDK/jindosdk-current/lib/*:/opt/apps/EMRHOOK/emrhook-current/spark-hook-spark30.jar:/opt/apps/SPARK3/gluten-current/*"\
                                    --conf spark.driver.extraClassPath="/opt/apps/METASTORE/metastore-current/hive2/*:/opt/apps/JINDOSDK/jindosdk-current/lib/*:/opt/apps/EMRHOOK/emrhook-current/spark-hook-spark30.jar:/opt/apps/SPARK3/gluten-current/*"\
                                   --database $DATASET"
setJarLink $testJar && cleanNodes && $CMD -f warmSkip72.sql  &> tmp/${testJar}_disHash_test1.log