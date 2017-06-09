#!/bin/bash

file=${1-"tux"}

if [[ -z "${2}" ]]; then
  cmmnd="fortune"
else
  cmmnd="echo -e ${2}"
fi

$cmmnd |cowsay -f $file |lolcat

