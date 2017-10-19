#!/usr/bin/env bash

#set -uoe >> /dev/null

wf=( $(cat "/var/lib/portage/world") )
uf="/etc/portage/package.use/stuff.use"
#uf="/tmp/test.use"

if [[ "${EUID}" -ne "0" ]]; then
  printf "Usage: sudo %s\n" "${0}"
  exit 1
else
  for line in "${wf[@]}"; do
    printf "%s doc\n" "${line}" >> "${uf}"
  done
fi
