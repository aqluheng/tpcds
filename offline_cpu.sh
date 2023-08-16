#!/bin/bash
for i in {16..32}
do
        echo $1 > /sys/devices/system/cpu/cpu$i/online
done
cat  /sys/devices/system/cpu/online