#!/bin/bash
filename=async-profiler-2.9-linux-arm64
outPath=/tmp/

sudo -u emr-user scp -r -o StrictHostKeyChecking=no $outPath/$filename core-1-1:
sudo -u emr-user scp -r -o StrictHostKeyChecking=no $outPath/$filename core-1-2:
sudo -u emr-user scp -r -o StrictHostKeyChecking=no $outPath/$filename core-1-3:

sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo rm -r $outPath/$filename
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo rm -r $outPath/$filename
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo rm -r $outPath/$filename

sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo mv $filename $outPath/$filename
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo mv $filename $outPath/$filename
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo mv $filename $outPath/$filename

