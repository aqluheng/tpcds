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
                                   --database parquet_1000 "

CMD=$glutencmd    

echo "-----------开始查询-----------"

pkill -f client_generate_nmon.py
python client_generate_nmon.py &
$CMD -f warmAll.sql  &> tmp/time_nmon.log

exit 0
