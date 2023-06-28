#!/bin/bash
mkdir -p tmp
for (( i=1;i<=50;++i ))
do
cd $SPARK_HOME/jars
cp -f -v gluten-velox-emr-2023-06-15-16-31.jar gluten-velox-bundle-spark3.3_2.12-alinux_3-0.5.0-SNAPSHOT.jar
cd -
sh my_velox_tpch.sh $1 $2 velox 3000 &>> luheng_bare_PTG_xxhash.log
mv tmp luheng_bare_PTG_xxhash_tmpdir
mkdir -p tmp

cd $SPARK_HOME/jars
cp -f -v gluten-bare-native gluten-velox-bundle-spark3.3_2.12-alinux_3-0.5.0-SNAPSHOT.jar
cd -
sh my_velox_tpch.sh $1 $2 velox 3000 &>> luheng_bare_native.log
mv tmp luheng_bare_native_tmpdir
mkdir -p tmp
done 

exit 0