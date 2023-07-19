mkdir -p parquet_dump
chmod a+w parquet_dump
rm parquet_dump/*
sudo -u emr-user scp -r -o StrictHostKeyChecking=no core-1-1:/tmp/save/* ./parquet_dump/
sudo -u emr-user scp -r -o StrictHostKeyChecking=no core-1-2:/tmp/save/* ./parquet_dump/
sudo -u emr-user scp -r -o StrictHostKeyChecking=no core-1-3:/tmp/save/* ./parquet_dump/