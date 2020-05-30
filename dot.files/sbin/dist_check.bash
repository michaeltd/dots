#!/usr/bin/env bash
#
# man qcheck : qcheck - verify integrity of installed packages
echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"

if (( EUID == 0 )); then
    time qcheck --quiet --nocolor --badonly 
else
    echo -ne " Privilaged access requirements not met!\n"
    exit 1
fi
