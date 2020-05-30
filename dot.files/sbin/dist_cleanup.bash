#!/usr/bin/env bash
#

echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"

if (( EUID == 0 )); then
    time eclean -Cpd packages -i
    time eclean -Cpd distfiles
else
    echo -ne " Privilaged access requirements not met!\n"
    exit 1
fi
