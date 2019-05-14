#!/bin/sh

source ~/.bashrc.d/functions.sh

function run {
  if ! pgrep $1
  then
    $@ &
  fi
}

rcm 9 compton -b

PMG="${HOME}/bin/pimp-my-gui.sh"
if [ -x "${PMG}" ]; then # If spice ...
  "${PMG}" & # Spice things up
fi
