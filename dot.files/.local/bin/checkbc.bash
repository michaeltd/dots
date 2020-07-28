#!/usr/bin/env -S bash --norc --noprofile

while :; do
    headers="$(bitcoin-cli -datadir=/mnt/el/.bitcoin getblockchaininfo|jq '.headers')"
    blocks="$(bitcoin-cli -datadir=/mnt/el/.bitcoin getblockchaininfo|jq '.blocks')"
    hmb="$(( headers - blocks ))"
    # echo "${hmb}"
    # clear
    printf "%04d\n" "${hmb}" |figlet |lolcat
    if [[ "${hmb}" -eq "0" ]]; then
	play -q -n synth .8 sine 4100 fade q 0.1 .3 0.1 repeat 3
	break
    fi
    sleep 120
done
