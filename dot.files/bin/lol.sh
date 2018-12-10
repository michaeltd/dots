#!/usr/bin/env bash
#
# Pipe fortune or second param through cowsay and lolcat for some color magic
# requires fortune, cowsay, lolcat.

file=${1-"eyes"}

if [[ -z "${2}" ]]; then
  cmmnd="fortune"
else
  cmmnd="echo -e ${2}"
fi

$cmmnd |cowsay -f $file |lolcat
