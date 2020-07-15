#!/usr/bin/env bash
#

echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"

command -v emerge &>/dev/null || { echo -ne "Need a portage based distro!\n" >&2; exit 1; }
(( EUID == 0 )) || { echo -ne "Privilaged access requirements not met!\n" >&2; exit 1; }

time eclean -Cpd packages -i
time eclean -Cpd distfiles
