#!/usr/bin/env bash

# Old rcm
# run() {
#   if ! pgrep $1
#   then
#     $@ &
#   fi
# }

# No double sourcing
[[ ! $(type -P rcm) ]] && source ~/.bashrc.d/30_functions.bash

rcm 9 compton -b

PMG="${HOME}/bin/pimp_my_gui.bash"
if [[ -x "${PMG}" ]]; then # If spice ...
  "${PMG}" & # Spice things up
fi
