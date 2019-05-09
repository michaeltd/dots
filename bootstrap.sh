#!/bin/sh
#
# bootstrap.sh
# The means to migrate my .dots in new systems.

if [ "${1}" != "thoushallnotpass" ]; then
  printf "${red}Read this first:${reset} ${bold}https://github.com/michaeltd/dots/blob/master/readme.md#bootstrap.sh${reset}\n" >&2
  exit 1
fi

DTFLS="$(cd $(dirname ${BASH_SOURCE[0]})/dot.files && pwd)"
TOFLD="${HOME}/test"
FX="$(date +%s)"
LS=$(which ls)
FLS=( $(${LS} -A ${DTFLS}) ) # No dot listings

# printf "\$DTFLS is %s, \$TOFLD is %s, \$FX is %s, \$LS is %s.\n" $DTFLS $TOFLD $FX $LS >&2
# printf "%s\n" "${FLS[@]}" >&2

for FL in ${FLS[@]}; do
  if [[ -L "${TOFLD}/${FL}" || -d "${TOFLD}/${FL}" || -f "${TOFLD}/${FL}" ]]; then
    mv -f "${TOFLD}/${FL}" "${TOFLD}/${FL}.${FX}"
  fi
  ln -sf "${DTFLS}/${FL}" "${TOFLD}/${FL}"
done
