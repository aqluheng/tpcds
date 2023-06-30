sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo echo 3 > /proc/sys/vm/drop_caches
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo echo 3 > /proc/sys/vm/drop_caches
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo echo 3 > /proc/sys/vm/drop_caches