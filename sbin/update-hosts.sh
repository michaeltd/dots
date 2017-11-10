#!/usr/bin/env /bin/bash
set -aeu

ts=$(date +%y%m%d.%H%M%S)
url="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
hf="/etc/hosts"
hb="/root/host.bkp/hb.${ts}.txt"
nh="/root/host.bkp/nh.${ts}.txt"

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
