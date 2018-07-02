#!/usr/bin/env bash
# check-integrity.sh: man qcheck : qcheck - verify integrity of installed packages
# qclog="/var/log/qcheck.${HOSTNAME}.${USER}.$(date +%y%m%d.%H%M%S).log"

printf "# INTEGRITY # ------------------------------------------------------------------\n"
nice -n 15 qcheck # >> "${qclog}" 2>&1
