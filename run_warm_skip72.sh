#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`

mkdir -p tmp

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
                                    --conf spark.gluten.enabled=true \
                                    --conf spark.executor.extraClassPath="/opt/apps/METASTORE/metastore-current/hive2/*:/opt/apps/JINDOSDK/jindosdk-current/lib/*:/opt/apps/EMRHOOK/emrhook-current/spark-hook-spark30.jar:/opt/apps/SPARK3/gluten-current/*"\
                                    --conf spark.driver.extraClassPath="/opt/apps/METASTORE/metastore-current/hive2/*:/opt/apps/JINDOSDK/jindosdk-current/lib/*:/opt/apps/EMRHOOK/emrhook-current/spark-hook-spark30.jar:/opt/apps/SPARK3/gluten-current/*"\
                                      --jars /opt/apps/SPARK3/gluten-current/gluten-thirdparty-lib-alinux-3.jar \
                                   --database parquet_1000 "

CMD=$glutencmd    

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
  $CMD -f warmSkip72.sql  &> tmp/${testJar}_test2.log
  $CMD -f warmSkip72.sql  &> tmp/${testJar}_test3.log
}

# testJar="gluten-shufflePatch"
# runJar

# testJar="gluten-master"
# runJar

testJar="gluten-2023-07-06"
runJar


exit 0
