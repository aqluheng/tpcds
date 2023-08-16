#!/bin/bash
filename=gluten-1.0.0-onlyLinear-64KB
outPath=/opt/apps/SPARK3/

sudo -u root scp -r -o StrictHostKeyChecking=no $outPath/$filename node1:
sudo -u root scp -r -o StrictHostKeyChecking=no $outPath/$filename node2:
sudo -u root scp -r -o StrictHostKeyChecking=no $outPath/$filename node3:

sudo -u root ssh -o StrictHostKeyChecking=no node1 sudo rm -r $outPath/$filename
sudo -u root ssh -o StrictHostKeyChecking=no node2 sudo rm -r $outPath/$filename
sudo -u root ssh -o StrictHostKeyChecking=no node3 sudo rm -r $outPath/$filename

sudo -u root ssh -o StrictHostKeyChecking=no node1 sudo mv $filename $outPath/$filename
sudo -u root ssh -o StrictHostKeyChecking=no node2 sudo mv $filename $outPath/$filename
sudo -u root ssh -o StrictHostKeyChecking=no node3 sudo mv $filename $outPath/$filename

