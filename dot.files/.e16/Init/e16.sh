#!/bin/sh
#
#shellcheck source=/dev/null

# No double sourcing
type rcm &>/dev/null || . ~/.bashrc.d/30_functions.bash

# rcm 9 wicd-gtk -t

# rcm 9 pasystray -a -m 100

# rcm 9 orage

PMG="${HOME}/.local/bin/pimp_my_gui.bash"
if [ -x "${PMG}" ]; then # If spice ...
    "${PMG}" # Spice things up
fi
