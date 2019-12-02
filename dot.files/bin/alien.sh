#!/bin/bash
# https://gist.githubusercontent.com/brunomiguel/efa59fe50a0ad361dbe99edb33aa02f0/raw/4979855b27f12f1b1abe572f58a06aab3e6e686c/gistfile1.txt

UPTIME_DAYS=$(( $(cut -d '.' -f1 /proc/uptime) % 31556926 / 86400 ))
UPTIME_HOURS=$(( $(cut -d '.' -f1 /proc/uptime) % 31556926 % 86400 / 3600 ))
UPTIME_MINUTES=$(( $(cut -d '.' -f1 /proc/uptime) % 31556926 % 86400 % 3600 / 60 ))

# Basic info
HOSTNAME=$(uname -n)
ROOT=$(df -Ph | grep -w sda1 | awk '{print $4}' | tr -d '\n')

# System load
MEMORY1=$(free -t -m | grep Total | awk '{print $3" MB";}')
MEMORY2=$(free -t -m | grep "Mem" | awk '{print $2" MB";}')
LOAD1=$(awk '{print $1}' /proc/loadavg)
LOAD5=$(awk '{print $2}' /proc/loadavg)
LOAD15=$(awk '{print $3}' /proc/loadavg)

cat << 'EOF'
.     .       .  .   . .   .   . .    +  .
  .     .  :     .    .. :. .___---------___.
       .  .   .    .  :.:. _".^ .^ ^.  '.. :"-_. .
    .  :       .  .  .:../:            . .^  :.:\.
        .   . :: +. :.:/: .   .    .        . . .:\
 .  :    .     . _ :::/:               .  ^ .  . .:\
  .. . .   . - : :.:./.                        .  .:\
  .      .     . :..|:                    .  .  ^. .:|
    .       . : : ..||        .                . . !:|
  .     . . . ::. ::\(                           . :)/
 .   .     : . : .:.|. ######              .#######::|
  :.. .  :-  : .:  ::|.#######           ..########:|
 .  .  .  ..  .  .. :\ ########          :######## :/
  .        .+ :: : -.:\ ########       . ########.:/
    .  .+   . . . . :.:\. #######       #######..:/
      :: . . . . ::.:..:.\           .   .   ..:/
   .   .   .  .. :  -::::.\.       | |     . .:/
      .  :  .  .  .-:.":.::.\             ..:/
 .      -.   . . . .: .:::.:.\.           .:/
.   .   .  :      : ....::_:..:\   ___.  :/
   .   .  .   .:. .. .  .: :.:.:\       :/
     +   .   .   : . ::. :.:. .:.|\  .:/|
     .         +   .  .  ...:: ..|  --.:|
.      . . .   .  .  . ... :..:.."(  ..)"
 .   .       .      :  .   .: ::/  .  .::\
EOF

echo -e "
===============================================
 - Hostname............: $HOSTNAME
 - Uptime..............: $UPTIME_DAYS days, $UPTIME_HOURS hours, $UPTIME_MINUTES minutes
 - Disk Space..........: $ROOT remaining
===============================================
 - CPU usage...........: $LOAD1, $LOAD5, $LOAD15 (1, 5, 15 min)
 - Memory used.........: $MEMORY1 / $MEMORY2
 - Swap in use.........: $(free -m | tail -n 1 | awk '{print $3}') MB
===============================================
"
