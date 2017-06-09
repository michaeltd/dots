#!/bin/bash

while [ true ]; do

  pid=`pgrep -x conky`

  if [[ -z $pid ]]; then
    conky -DDDD -b -c ~/.conky.conf/conkyconf.green.conkyrc >> ~/.conky.err/`date +%y%m%d`.conky.err.log 2>&1
  else
    sleep 30
  fi

done
