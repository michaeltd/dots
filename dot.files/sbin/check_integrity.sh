#!/bin/bash
#
# ~/sbin/check_integrity.sh
# man qcheck : qcheck - verify integrity of installed packages

printf " -- %s --\n" "$(basename ${BASH_SOURCE[0]})"

if (( EUID == 0 )); then
  time qcheck
fi
