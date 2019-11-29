#!/usr/bin/env bash
#
# ~/bin/alarm.sh
#
# crontab
# For details see man 4 crontabs
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
# 00 08 * * 1-5 ~/bin/alarm.sh
#
# 00 07 * * 1-5 bash -lc "at -m -f ~/bin/alarm.sh now + 1 hour"
#
# at -m -f ~/bin/alarm.sh now

echo -ne "= $(basename "${0}") =\n"

# mpg123 -Z /mnt/data/Documents/Music/Stanley-Clarke/* /mnt/data/Documents/Music/Marcus-Miller/* /mnt/data/Documents/Music/Jaco-Pastorius/* /mnt/data/Documents/Music/Esperanza-Spalding/* /mnt/data/Documents/Music/Mark-King/Level\ Best/*

# mplayer -shuffle -msglevel all=3 /mnt/data/Documents/Music/Stanley-Clarke/* /mnt/data/Documents/Music/Marcus-Miller/* /mnt/data/Documents/Music/Jaco-Pastorius/* /mnt/data/Documents/Music/Esperanza-Spalding/* /mnt/data/Documents/Music/Mark-King/Level\ Best/*

cvlc --random file:///mnt/data/Documents/Music/Stanley-Clarke/ file:///mnt/data/Documents/Music/Marcus-Miller/ file:///mnt/data/Documents/Music/Jaco-Pastorius/ file:///mnt/data/Documents/Music/Esperanza-Spalding/ file:///mnt/data/Documents/Music/Mark-King/Level\ Best/
