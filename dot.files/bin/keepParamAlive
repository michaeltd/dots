#!/usr/bin/env bash
# Take an application (first parameter) and respawn it periodicaly (second parameter) if it crashes
# EG: "keepParamAlive conky 15" Will check every 15sec if conky is running and launch it if not
if [[ -z "${1}" || -z $(which "${1}") ]]; then # Test param
  printf "Need an application as parameter.\n\"%s\" was not found in your PATH.\n" "${1}"
  exit 1
else
  while [[ true ]]; do # Endless loop.
    pid=$(pgrep -x "${1}") # Get a pid.
    if [[ -z "${pid}" ]]; then # If there is none, start it in the background.
      "${1}" &
    else # Else wait.
      sleep ${2-"60"}
    fi
  done
fi
