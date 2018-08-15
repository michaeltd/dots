#!/usr/bin/env bash
# ~/sbin/serve-things.sh start|stop

if [[ -z "${1}" || "${EUID}" -ne "0" ]]; then
  printf "%s requires root privilages and a parameter.\nUsage: sudo %s start|stop\n" ${BASH_SOURCE[0]} ${BASH_SOURCE[0]}
  exit 1
fi

declare -a srvcs=( "postgresql-10" "apache2" "vsftpd" "sshd" "rsyncd" "dictd" )

for srvc in "${srvcs[@]}"; do
  rc-service "${srvc}" "${1}"
done
