#!/bin/sh
#
# bootstrap.sh
# The means to migrate my .dots in new systems.

set -e

if [ "${1}" != "thoushallnotpass" ]; then
  #shellcheck disable=SC2154
  echo "${red}Read this first:${reset} ${bold}https://github.com/michaeltd/dots/blob/master/readme.md#bootstrap.sh${reset}" >&2
  exit "1"
fi

DTFLS="$(cd "$(dirname "${0}")/dot.files" && pwd -P)"
TOFLD="${HOME}"
FX="$(date +%s)"
#shellcheck disable=SC2230
LS="$(which ls)"

for FL in $("${LS}" "-A" "${DTFLS}"); do
  if [ -e "${TOFLD}/${FL}" ]; then
    mv -f "${TOFLD}/${FL}" "${TOFLD}/${FL}.${FX}"
  fi
  ln -sf "${DTFLS}/${FL}" "${TOFLD}/${FL}"
done
