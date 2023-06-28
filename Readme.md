## TPCDS_基准代码库
#### 火焰图配置
1. ln -s /etc/taihao-apps/spark-conf/ ./
2. cp spark-conf/spark-defaults.conf spark-conf/spark-defaults.conf.bak


#### 可用命令(火焰图无关)
1. bash my_repeat.sh 1 99               重复执行tpcds指令
2. bash my_velox_tpcds.sh 1 99          执行一轮tpcds指令
3. bash my_velox_tpch.sh 1 22           执行一轮tpch指令
4. bash run_warm_all.sh                 在预热条件下, 执行一轮tpcds指令

#### 可用命令(火焰图相关)
1. bash my_velox_tpcds_HotGraph.sh 1 99 执行一轮tpcds指令, 生成火焰图
2. bash my_velox_tpcds_HotFold.sh 1 99  执行一轮tpcds指令, 生成火焰图数据
3. bash gatherFlameGraph.sh             单独收集所有节点上的火焰图/火焰图数据