#!/bin/sh

# No double sourcing
[ ! $(command -v rcm) ] && source ~/.bashrc.d/functions.sh

run() {
  if ! pgrep $1
  then
    $@ &
  fi
}

rcm 9 compton -b

PMG="${HOME}/bin/pimp_my_gui.bash"
if [ -x "${PMG}" ]; then # If spice ...
  "${PMG}" & # Spice things up
fi
