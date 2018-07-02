#!/usr/bin/env bash

declare -a dtls=( "baseboard-manufacturer" "system-version" "system-product-name" "chassis-type" "system-serial-number" "bios-release-date" "bios-version" )

for i in "${dtls[@]}"; do
  echo "$i : $(sudo dmidecode -s $i)"
done
