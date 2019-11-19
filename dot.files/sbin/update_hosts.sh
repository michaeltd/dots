#!/bin/bash
#
# ~/sbin/update_hosts.sh
# 1) Set a strict /etc/hosts file 2) Make sure you have one

PROTOCOL="https://"

DOMAIN="raw.githubusercontent.com"

PAGE="StevenBlack/hosts/master/hosts"

URL="${PROTOCOL}${DOMAIN}/${PAGE}"

HOSTS_FILE="/etc/hosts"

RANDOM_TEMP_FILE="/tmp/${RANDOM}.$$"

printf " -- %s --\n" "$(basename ${BASH_SOURCE[0]})"

#curl "${URL}" > "${RANDOM_TEMP_FILE}"

wget -q -O - "${URL}" > "${RANDOM_TEMP_FILE}"

BYTES=($(wc -c "${RANDOM_TEMP_FILE}"))

if (( ${BYTES[0]} == 0 || EUID != 0 )); then
  printf "\$EUID != 0 or ${RANDOM_TEMP_FILE} is empty (zero bytes in size).\nCheck your network status or/and status of this page:\n${URL}\n" >&2
  exit 1
else
  printf "cat ${RANDOM_TEMP_FILE} > ${HOSTS_FILE}\n"
  cat "${RANDOM_TEMP_FILE}" > "${HOSTS_FILE}"
fi
