#!/usr/bin/env bash
#
# ~/sbin/update-hosts.sh
# 1) Set a strict /etc/hosts file 2) Make sure you have one

PROTOCOL="https://"
DOMAIN="raw.githubusercontent.com"
PAGE="StevenBlack/hosts/master/hosts"
URL="${PROTOCOL}${DOMAIN}/${PAGE}"
HOSTS_FILE="/etc/hosts"
RANDOM_TEMP_FILE="/tmp/${RANDOM}.$$"
printf "# HOSTS # ----------------------------------------------------------------------\n"

printf "curl ${URL} > ${RANDOM_TEMP_FILE}\n"
curl "${URL}" > "${RANDOM_TEMP_FILE}"

printf "BYTES=(\$(wc -c ${RANDOM_TEMP_FILE}))\n"
BYTES=($(wc -c "${RANDOM_TEMP_FILE}"))

if (( ${BYTES[0]} == 0 )); then
  printf "${RANDOM_TEMP_FILE} is empty (zero bytes in size).\nCheck your network status or/and status of this page:\n${URL}\n"
  exit
else
  printf "cat ${RANDOM_TEMP_FILE} > ${HOSTS_FILE}\n"
  cat "${RANDOM_TEMP_FILE}" > "${HOSTS_FILE}"
fi
