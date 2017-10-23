#!/usr/bin/env /bin/bash

if [[ -z "${1}" || -z $(which "${1}") ]]; then # Test param
  printf "Need an application as parameter.\n\"%s\" has not been found in \$PATH env var.\n" "${1}"
  exit 1
else
  while [[ true ]]; do # Endless loop.
    pid=$(pgrep -x "${1}") # Get a pid.
    if [[ -z "${pid}" ]]; then # If there is none,
      "${1}" & # Start Param to background.
    else
      sleep ${2-"15"} # Wait.
    fi
  done
fi
