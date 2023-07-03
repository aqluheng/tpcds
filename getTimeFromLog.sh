FILE=$1

time=`cat $FILE | grep "Time taken:" | awk -F 'Time taken:' '{print $2}' | awk -F ' ' '{print $1}'`
echo $time