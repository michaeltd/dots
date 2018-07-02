#!/usr/bin/env bash
# update-hosts.sh
url="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
hf="/etc/hosts"

printf "# HOSTS # ----------------------------------------------------------------------\n"
curl "${url}" > "${hf}"
