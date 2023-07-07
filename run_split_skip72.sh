#!/bin/bash
version="gluten-2023-07-07"

source utils/helper-functions.sh
setJarLink $version


for (( i=1;i<=99;++i ))
do
    case $i in
      72)
      continue
        ;;
      *)
        ;;
    esac
    file="qualification-queries/query$i.sql"
    if [ ! -f $file ];then
        echo "$file is not exist! 没有该条语句"
        exit 1
    fi
    $CMD -f "$file" &>> tmp/split-${version}_test1.log
done

for (( i=1;i<=99;++i ))
do
    file="$SPARK_SQL/query$i.sql"
    if [ ! -f $file ];then
        echo "$file is not exist! 没有该条语句"
        exit 1
    fi
    $CMD -f "$file" &>> tmp/split-${version}_test2.log
done

for (( i=1;i<=99;++i ))
do
    file="$SPARK_SQL/query$i.sql"
    if [ ! -f $file ];then
        echo "$file is not exist! 没有该条语句"
        exit 1
    fi
    $CMD -f "$file" &>> tmp/split-${version}_test3.log
done

exit 0