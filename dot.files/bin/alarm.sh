#!/usr/bin/env bash
#
# ~/bin/alarm.sh

echo -ne " -- $(basename "${0}") --\n"

# mpg123 -Z /mnt/data/Documents/Music/Stanley-Clarke/* /mnt/data/Documents/Music/Marcus-Miller/* /mnt/data/Documents/Music/Jaco-Pastorius/* /mnt/data/Documents/Music/Esperanza-Spalding/* /mnt/data/Documents/Music/Mark-King/Level\ Best/*

# mplayer -shuffle -msglevel all=3 /mnt/data/Documents/Music/Stanley-Clarke/* /mnt/data/Documents/Music/Marcus-Miller/* /mnt/data/Documents/Music/Jaco-Pastorius/* /mnt/data/Documents/Music/Esperanza-Spalding/* /mnt/data/Documents/Music/Mark-King/Level\ Best/*

cvlc --random file:///mnt/data/Documents/Music/Stanley-Clarke/ file:///mnt/data/Documents/Music/Marcus-Miller/ file:///mnt/data/Documents/Music/Jaco-Pastorius/ file:///mnt/data/Documents/Music/Esperanza-Spalding/ file:///mnt/data/Documents/Music/Mark-King/Level\ Best/
