#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096
#
# 1) Set a strict /etc/hosts file
# 2) Make sure you have one

[[ "${EUID}" -ne "0" ]] && echo -ne "\$EUID != 0.\nTry: sudo ${BASH_SOURCE[0]##*/}.\n" >&2 && exit 1

url="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"

hosts_file="/etc/hosts"

random_file="/tmp/${RANDOM}.$$"

curl -sS "${url}" > "${random_file}"

#shellcheck disable=SC2207
bytes=($(wc -c "${random_file}"))

if [[ "${bytes[0]}" -eq "0" ]]; then
    echo -ne "${random_file} is empty (zero bytes in size).\nCheck your network status and/or status of this page:\n${url}\n" >&2
    exit 1
else
    echo -ne "cat ${random_file} > ${hosts_file}\n"
    cat "${random_file}" > "${hosts_file}"
fi
