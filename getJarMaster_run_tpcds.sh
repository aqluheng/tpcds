#!/bin/bash
source /root/.bashrc

# date=$(date +%Y-%m-%d)
date="2023-07-06"

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
                                      --jars /opt/apps/SPARK3/gluten-current/gluten-thirdparty-lib-alinux-3.jar \
                                   --database parquet_1000 "


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

veloxpath=`ossutil ls oss://ptg-storage/bigdata/gluten/release/ | grep gluten-velox-emr-master-$date.* | sed -n 's/.*\(oss:\/\/.*\.jar\).*/\1/p'` # eg: oss://ptg-storage/bigdata/gluten/release/gluten-velox-emr-2023-06-16-10-59.jar
veloxfile=${veloxpath##*/} # eg: gluten-velox-emr-2023-06-16-10-59.jar


thirdpartypath=`ossutil ls oss://ptg-storage/bigdata/gluten/release/ | grep gluten-thirdparty-emr-master-$date.* | sed -n 's/.*\(oss:\/\/.*\.jar\).*/\1/p'` # eg: oss://ptg-storage/bigdata/gluten/release/gluten-thirdparty-emr-2023-06-16-10-59.jar
thirdpartyfile=${veloxpath##*/} # eg: gluten-thirdparty-emr-2023-06-16-10-59.jar

echo Use jar from $ossfile $thirdpartyfile > tpcds/tmp/time.csv
mkdir -p /opt/apps/SPARK3/gluten-master-$date/
ossutil cp $veloxpath /opt/apps/SPARK3/gluten-master-$date/gluten-velox-bundle-spark3.3_2.12-alinux_3-0.5.0-SNAPSHOT.jar
ossutil cp $thirdpartypath /opt/apps/SPARK3/gluten-master-$date/gluten-thirdparty-lib-alinux-3.jar

sendToNodes /opt/apps/SPARK3 gluten-master-$date

testJar="gluten-master-$date"
runJar