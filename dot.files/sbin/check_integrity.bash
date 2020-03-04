#!/usr/bin/env bash
#
# ~/sbin/check_integrity.bash
# man qcheck : qcheck - verify integrity of installed packages

echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"

if (( EUID == 0 )); then
    time qcheck
fi
