import time
import os

filename = "tmp/time_nmon.log"
print(filename)
nowTimeCount = 0

hostnameStr = os.popen("hostname").read().strip()
if hostnameStr == "master":
    print("use node1")
    startShell = "sudo -u root ssh -o StrictHostKeyChecking=no node1 sudo nmon -F query%d.nmon -s 1 -c 500 -p"
    endShell =  "sudo -u root ssh -o StrictHostKeyChecking=no node1 sudo kill -9 %d"
else:
    print("use core-1-1")
    startShell = "sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo nmon -F query%d.nmon -s 1 -c 500 -p"
    endShell =  "sudo -u emr-user ssh -o StrictHostKeyChecking=no core-1-1 sudo kill -9 %d"

while True:
    pid = int(os.popen(startShell % nowTimeCount).read().strip())
    with open(filename, 'r') as f:
        while True:
            lineCount = int(os.popen('grep "Time taken" %s | wc -l'%filename).read().strip())
            if lineCount != nowTimeCount:
                nowTimeCount = lineCount
                break
            time.sleep(0.5)
    os.system(endShell % pid)
    print("%d generated"%nowTimeCount)

print("Client program terminated")