#!/usr/bin/env bash
#
# man qcheck : qcheck - verify integrity of installed packages
echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"

command -v emerge &>/dev/null || { echo -ne "\n Need a Gentoo distro!\n"; exit 1; }

if (( EUID == 0 )); then
    times qcheck --quiet --nocolor --badonly 
else
    echo -ne " Privilaged access requirements not met!\n"
    exit 1
fi
