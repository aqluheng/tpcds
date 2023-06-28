#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`

SPARK_DIR=/root/tpcds
SPARK_RESULT_DIR=$SPARK_DIR/tmp
SPARK_SQL=$SPARK_DIR/tpch


if [ ! -d $SPARK_SQL ];then
        echo "query sql is not exist,exit.."
	exit;
fi

glutencmd="spark-sql --master yarn \
          --deploy-mode client \
            --conf spark.driver.cores=8 \
              --conf spark.driver.memory=20g \
                --conf spark.executor.instances=50 \
                  --conf spark.executor.cores=7 \
                    --conf spark.executor.memory=4G \ 
                      --conf spark.plugins=io.glutenproject.GlutenPlugin \
                        --conf spark.gluten.sql.columnar.backend.lib=velox \
                          --conf spark.executorEnv.VELOX_HDFS="hdfs://master-1-1:9000" \
                            --conf spark.shuffle.manager=org.apache.spark.shuffle.sort.ColumnarShuffleManager \
                              --conf spark.memory.offHeap.enabled=true \
                                --conf spark.memory.offHeap.size=8g \ 
                                  --conf spark.executor.memoryOverhead=512m \
                                    --conf spark.driver.maxResultSize=32g \
                                   --database tpch_velox_5000 "

CMD=$glutencmd    
echo "-----------开始查询-----------"

for (( i=$1;i<=$2;++i ))
do
    case $i in 
      10) # hash语句
      ;;
      18|21) # 推荐跳过
      continue
      ;;
      *)
      ;;
      # continue
    esac

    file="$SPARK_SQL/$i.sql"
    if [ ! -f $file ]; then
        echo "$file is not exist!"
        exit 1
    fi
    sysout="$SPARK_RESULT_DIR/query${i}.out"    
    echo -n "" > tmp/query$i.out
    $CMD -f "$file"  > $sysout 2>&1
    time=`cat $sysout | grep "Time taken:" | awk -F 'Time taken:' '{print $2}' | awk -F ' ' '{print $1}'`
    echo "query${i}=${time}"
done

exit 0