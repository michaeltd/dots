#!/usr/bin/env /bin/bash
#
#for x in {1..254}; do
  for y in {1..254}; do
    (ping -c 1 -w 2 192.168.1.${y} > /dev/null && echo "UP 192.168.1.${y}" &);
  done
#done
