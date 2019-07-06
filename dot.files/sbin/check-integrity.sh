#!/usr/bin/env bash
#
# ~/sbin/check-integrity.sh
# man qcheck : qcheck - verify integrity of installed packages

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

(( EUID == 0 )) && time qcheck
