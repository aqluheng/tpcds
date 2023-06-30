#!/bin/bash
sudo -u emr-user scp -r -o StrictHostKeyChecking=no core-1-1:/home/emr-user/test.nmon ./nmonFile/test.nmon
./nmonchart-master/nmonchart ./nmonFile/test.nmon