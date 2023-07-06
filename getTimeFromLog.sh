FILE=$1

cat $FILE | grep "Time taken:" | awk -F 'Time taken:' '{print $2}' | awk -F ' ' '{print $1}' > tmp1
tail -n +2 tmp1 > tmpLog.log
rm -f tmp1