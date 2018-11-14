#!/usr/bin/env bash
#
# ~/sbin/update-hosts.sh
# Set a strict /etc/hosts file

url="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
hf="/etc/hosts"

printf "# HOSTS # ----------------------------------------------------------------------\n"
curl "${url}" > "${hf}"
printf "0.0.0.0 www.facebook.com\n0.0.0.0 fb.com\n0.0.0.0 www.twitter.com\n0.0.0.0 twitter.com\n" >> "${hf}"
