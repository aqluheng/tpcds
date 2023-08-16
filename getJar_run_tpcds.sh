#!/bin/bash
source /root/.bashrc

date=$(date +%m-%d)
cleanNodes(){
  slave_node_num=${1:-3}

  hostname=$(hostname)
  if [[ $hostname == *"master-1-1"* ]]; then
      slave_name="core-1-"
      user_name="emr-user"
  else
      slave_name="node"
      user_name="root"
  fi

  for i in $(seq $slave_node_num)
  do
    echo "clean memory for $slave_name$i ..."
    sudo -u $user_name ssh -o StrictHostKeyChecking=no $user_name@$slave_name$i "sudo sh -c 'sync && echo 3 > /proc/sys/vm/drop_caches'"
  done

  echo "clean memory for master ..."
  sudo sh -c 'sync && echo 3 > /proc/sys/vm/drop_caches'
}


sendToNodes(){
    outPath=$1
    filename=$2
    echo $outPath $filename
    sudo -u emr-user scp -r -o StrictHostKeyChecking=no $outPath/$filename core-1-1:
    sudo -u emr-user scp -r -o StrictHostKeyChecking=no $outPath/$filename core-1-2:
    sudo -u emr-user scp -r -o StrictHostKeyChecking=no $outPath/$filename core-1-3:

    sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo mkdir -p $outPath
    sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo mkdir -p $outPath
    sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo mkdir -p $outPath

    sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo rm -r $outPath/$filename
    sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo rm -r $outPath/$filename
    sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo rm -r $outPath/$filename

    sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo mv $filename $outPath/$filename
    sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo mv $filename $outPath/$filename
    sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo mv $filename $outPath/$filename
}

CMD="spark-sql --master yarn \
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
                                   --database parquet_1000"


runJar(){
  rm /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo rm /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo rm /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo rm /opt/apps/SPARK3/gluten-current
  ln -s /opt/apps/SPARK3/$testJar /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo ln -s /opt/apps/SPARK3/$testJar /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo ln -s /opt/apps/SPARK3/$testJar /opt/apps/SPARK3/gluten-current
  sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo ln -s /opt/apps/SPARK3/$testJar /opt/apps/SPARK3/gluten-current
  mkdir -p everydayLog/${testJar}/
  cleanNodes && $CMD -f warmSkip72.sql  &> everydayLog/${testJar}/test1.log
  cleanNodes && $CMD -f warmSkip72.sql  &> everydayLog/${testJar}/test2.log
  cleanNodes && $CMD -f warmSkip72.sql  &> everydayLog/${testJar}/test3.log
}


ossutil cp -r oss://ptg-storage/bigdata/gluten/release/opensource-$date /opt/apps/SPARK3/
if [ -d "/opt/apps/SPARK3/opensource-$date" ]; then
  sendToNodes opensource-$date
  testJar="opensource-$date"
  runJar
fi