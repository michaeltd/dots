#!/usr/bin/env bash
# bootstrap.sh
# The means to migrate my .dots in new systems.

if [[ "${1}" != "thoushallnotpass" ]]; then
  printf "${red}Read this first:${reset} ${bold}https://github.com/michaeltd/dots/blob/master/readme.md#bootstrap.sh${reset}\n" >&2
  exit 1
fi

dtfls="$(cd $(dirname ${BASH_SOURCE[0]})/dot.files && pwd)"
tofldr="${HOME}"
fx=".$(date +%s)"
ls=$(which ls) # Full path

declare -a fls=( $(${ls} -A ${dtfls}) ) # No dot listings

for file in ${fls[@]}; do
  if [[ -L "${tofldr}/${file}" || -d "${tofldr}/${file}" || -f "${tofldr}/${file}" ]]; then
    mv -f "${tofldr}/${file}" "${tofldr}/${file}${fx}"
  fi
  ln -sf "${dtfls}/${file}" "${tofldr}/${file}"
done
