#!/bin/bash

while [ true ]; do     # Endless loop.

  pid=`pgrep -x ${1}`  # Get a pid.

  if [[ -z $pid ]]; then # If there is none,
    ${1} &             # Start Param to background.
  else
    sleep 60           # Else wait.
  fi

done
