#!/usr/bin/env bash

ts=$(date +%y%m%d.%H%M%S)
url="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
hf="/etc/hosts"
hb="/etc/hosts.${ts}.txt"
nh="${HOME}/${ts}.hosts.txt"

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
