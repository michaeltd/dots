#!/usr/bin/env bash

file=${1-"eyes"}

if [[ -z "${2}" ]]; then
  cmmnd="fortune"
else
  cmmnd="echo -e ${2}"
fi

$cmmnd |cowsay -f $file |lolcat
