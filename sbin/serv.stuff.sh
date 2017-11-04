#!/usr/bin/env /bin/bash

set -aeu

srvcs=( postgresql-9.6 vsftpd apache2 sshd )

if [[ "${EUID}" -ne "0" ]]; then
  printf "Need root privilages\n"
  exit 1
else
  if [[ -z "${1}" ]]; then
    echo "need start or stop parameter"
    exit 1
  else
    for srvc in "${srvcs[@]}"; do
      rc-service "${srvc}" "${1}"
    done
  fi
fi
