#!/usr/bin/env bash
# https://unix.stackexchange.com/questions/22615/how-can-i-get-my-external-ip-address-in-a-shell-script

curl -s http://whatismyip.akamai.com/
# dig +short myip.opendns.com @resolver1.opendns.com
