# 1+3机器上,将3台机器上的/var/flamegraph分别翻入flamegraph/core-1-1, flamegraph/core-1-2, flamegraph/core-1-3
rm flamegraph/*
sudo -u emr-user scp -r -o StrictHostKeyChecking=no core-1-1:/var/flamegraph ./
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo -u root  rm -f /var/flamegraph/*