#!/usr/bin/env bash
#
# ~/sbin/update-hosts.sh
# Set a strict /etc/hosts file

url="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
hf="/etc/hosts"

printf "# HOSTS # ----------------------------------------------------------------------\n"
curl "${url}" > "${hf}"
