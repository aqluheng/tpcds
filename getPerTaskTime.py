#!/bin/python
import os
import re
import sys

filename = sys.argv[1]
assignCMD = "grep 'YarnCoarseGrainedExecutorBackend: Got assigned task' %s"
runningCMD = "grep 'Executor: Running task .* in stage .* (TID .*)' %s"
finishCMD = "grep 'Executor: Finished task .* in stage .* (TID .*)' %s"

assignLines = os.popen(assignCMD % filename).read().strip().split('\n')
runningLines = os.popen(runningCMD % filename).read().strip().split('\n')
finishLines = os.popen(finishCMD % filename).read().strip().split('\n')

assignTimeMap = {}
for line in assignLines:
    pattern = r"task .*$"
    pattern2 = r"[0-9][0-9]:[0-9][0-9]:[0-9][0-9]"
    taskId = int(re.findall(pattern, line)[0][5:]) # task 1454, 
    timeStr = re.findall(pattern2, line)[0] # 16:59:02
    assignTimeMap[taskId] = timeStr


runningTimeMap = {}
for line in runningLines:
    pattern = r"(TID [0-9]+)"
    pattern2 = r"[0-9][0-9]:[0-9][0-9]:[0-9][0-9]"
    taskId = int(re.findall(pattern, line)[0][4:]) # TID 1454, 
    timeStr = re.findall(pattern2, line)[0] # 16:59:02
    runningTimeMap[taskId] = timeStr


finishTimeMap = {}
for line in finishLines:
    pattern = r"(TID [0-9]+)"
    pattern2 = r"[0-9][0-9]:[0-9][0-9]:[0-9][0-9]"
    taskId = int(re.findall(pattern, line)[0][4:]) # TID 1454, 
    timeStr = re.findall(pattern2, line)[0] # 16:59:02
    finishTimeMap[taskId] = timeStr

taskNum = len(assignTimeMap)

from datetime import datetime
def time_diff(str1, str2):
    # 将时间字符串转换为datetime对象
    time1 = datetime.strptime(str1, "%H:%M:%S")
    time2 = datetime.strptime(str2, "%H:%M:%S")

    return int((time2 - time1).total_seconds())

assignToRun = []
runToFinish = []
for i in range(taskNum):
    assignTime = assignTimeMap[i]
    runningTime = runningTimeMap[i]
    finishTime = finishTimeMap[i]
    assignToRun.append(time_diff(runningTime, assignTime))
    runToFinish.append(time_diff(runningTime, finishTime))

print("分配到运行")
top10 = sorted(assignToRun, reverse=True)[:10]
for i, num in enumerate(top10):
    print(f"第{i+1}大的数是{num}，位置是{assignToRun.index(num)}")

print("运行到结束")
top10 = sorted(runToFinish, reverse=True)[:10]
for i, num in enumerate(top10):
    print(f"第{i+1}大的数是{num}，位置是{[j for j, x in enumerate(runToFinish) if x == num]}")