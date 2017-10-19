#!/usr/bin/env /bin/bash

if [[ "${EUID}" -ne "0" ]]; then
  printf "Need root privilages\n"
  exit 1
else
  mount /mnt/el
  rc-service dhcpcd restart
fi
