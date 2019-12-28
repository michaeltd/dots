#!/usr/bin/env bash
#
# ~/bin/keepParamAlive.sh
# Take an application (first parameter) and respawn it periodicaly (second parameter) if it crashes
# EG: "keepParamAlive conky 15" Will check every 15sec if conky is running and launch it if not


if [[ -z "${1}" || -z "$(type -P "${1}")" ]]; then # Test param
  echo -ne " Usage: $(basename "${0}") 'executable' [delay (in seconds)].\n $(basename "${0}") will check if 'executable' is running \n and relaunch it in 'delay' seconds if not.\n" >&2
  exit 1
else
  while :; do # Endless loop.
    if [[ -z "$(pgrep "${1}")" ]]; then # If there is none, start it in the background.
      "${1}" &
      sleep "${2:-15}"
    else # Else wait.
      sleep "${2:-15}"
    fi
  done
fi
