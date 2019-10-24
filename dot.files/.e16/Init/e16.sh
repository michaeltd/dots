#!/usr/bin/env bash

# No double sourcing
[[ ! $(command -v rcm) ]] && source ~/.bashrc.d/functions.sh

rcm 9 wicd-gtk -t

rcm 9 pasystray -a -m 100

PMG="${HOME}/bin/pimp-my-gui.sh"
if [[ -x "${PMG}" ]]; then # If spice ...
  "${PMG}" & # Spice things up
fi
