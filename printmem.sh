#!/usr/bin/env /bin/bash

total=$(cat /proc/meminfo |head -1 |awk '{print $2}')
avail=$(cat /proc/meminfo |head -2 |tail -1 |awk '{print $2}')
used=$(expr ${total} - ${avail})
totalMB=$(expr ${total} / 1024)
availMB=$(expr ${avail} / 1024)
usedMB=$(expr ${used} / 1024)
printf "From a total of %d memory, you are using %d MB's, which leaves you with %d MB free.\n" $totalMB $usedMB $availMB
