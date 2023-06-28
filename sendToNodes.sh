#!/bin/bash
file=gluten-new-compile
outPath=/opt/apps/SPARK3
if [ -z "$file" ]; then
    echo "sned_to_nodes.sh $file"
    exit 0
fi

filename=$(basename "$file")
sudo -u emr-user scp -r -o StrictHostKeyChecking=no $outPath/$file core-1-1:
sudo -u emr-user scp -r -o StrictHostKeyChecking=no $outPath/$file core-1-2:
sudo -u emr-user scp -r -o StrictHostKeyChecking=no $outPath/$file core-1-3:

cp $file /usr/lib64/$filename
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo rm -r $outPath/$filename
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo rm -r $outPath/$filename
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo rm -r $outPath/$filename

sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo mv $filename $outPath/$filename
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-2 sudo mv $filename $outPath/$filename
sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-3 sudo mv $filename $outPath/$filename

