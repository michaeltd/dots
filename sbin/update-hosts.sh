#!/usr/bin/env /bin/bash

set -aeu

ts=$(date +%y%m%d.%H%M%S)
url="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
hf="/etc/hosts"
hb="/root/hb.${ts}.txt"
nh="/root/nh.${ts}.txt"

if [[ "${EUID}" -ne "0" ]]; then
  printf "Need root privilages\n"
  exit 1
else
  curl "${url}" > "${nh}"
  mv "${hf}" "${hb}"
  cp "${nh}" "${hf}"
  chown --reference="${hb}" "${hf}"
  chmod --reference="${hb}" "${hf}"
fi
