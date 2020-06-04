#!/usr/bin/env bash
#

echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"

command -v emerge &>/dev/null || { echo -ne "\n Need a Gentoo distro!\n"; exit 1; }

if (( EUID == 0 )); then
    time eclean -Cpd packages -i
    time eclean -Cpd distfiles
else
    echo -ne " Privilaged access requirements not met!\n"
    exit 1
fi
