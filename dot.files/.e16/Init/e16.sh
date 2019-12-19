#!/bin/bash
#
#shellcheck source=/dev/null

# No double sourcing
[[ -z "$(command -v rcm)" ]] && source ~/.bashrc.d/functions.sh

rcm 9 wicd-gtk -t

rcm 9 pasystray -a -m 100

rcm 9 orage

PMG="${HOME}/bin/pimp_my_gui.sh"
if [[ -x "${PMG}" ]]; then # If spice ...
  "${PMG}" & # Spice things up
fi
