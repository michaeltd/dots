#!/usr/bin/env bash
#
# ~/sbin/update_hosts.bash
# 1) Set a strict /etc/hosts file 2) Make sure you have one
echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"

PROTOCOL="https://"

DOMAIN="raw.githubusercontent.com"

PAGE="StevenBlack/hosts/master/hosts"

URL="${PROTOCOL}${DOMAIN}/${PAGE}"

HOSTS_FILE="/etc/hosts"

RANDOM_FILE="/tmp/${RANDOM}.$$"

curl "${URL}" > "${RANDOM_FILE}"

#wget -q -O - "${URL}" > "${RANDOM_FILE}"

#shellcheck disable=SC2207
BYTES=($(wc -c "${RANDOM_FILE}"))

if [[ "${BYTES[0]}" -eq "0" || "${EUID}" != "0" ]]; then
    echo -ne "\$EUID != 0 or ${RANDOM_FILE} is empty (zero bytes in size).\nCheck your network status or/and status of this page:\n${URL}\n" >&2
    exit 1
else
    echo -ne "cat ${RANDOM_FILE} > ${HOSTS_FILE}\n"
    cat "${RANDOM_FILE}" > "${HOSTS_FILE}"
fi
