#!/usr/bin/env bash
#
# ~/sbin/update_hosts.bash
# 1) Set a strict /etc/hosts file 2) Make sure you have one
echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"

url="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"

hosts_file="/etc/hosts"

random_file="/tmp/${RANDOM}.$$"

curl "${url}" > "${random_file}"

#wget -q -O - "${URL}" > "${RANDOM_FILE}"

#shellcheck disable=SC2207
bytes=($(wc -c "${random_file}"))

if [[ "${bytes[0]}" -eq "0" || "${EUID}" != "0" ]]; then
    echo -ne "\$EUID != 0 or ${random_file} is empty (zero bytes in size).\nCheck your network status or/and status of this page:\n${url}\n" >&2
    exit 1
else
    echo -ne "cat ${random_file} > ${hosts_file}\n"
    cat "${random_file}" > "${hosts_file}"
fi
