#!/usr/bin/env bash
#
# ~/bin/plug-dots.sh
# The means to migrate my .dots in new systems.

dtfls="$(cd ../$(dirname ${BASH_SOURCE[0]}) && pwd)" # One down from this one (bin/plug-dots.sh)

tofldr="${HOME}"
fx=".$(date +%s)"
ls=$(which ls) # alias workaround

declare -a fls=( $(${ls} -A ${dtfls}) )

for file in ${fls[@]}; do
  if [[ -L "${tofldr}/${file}" || -d "${tofldr}/${file}" || -f "${tofldr}/${file}" ]]; then
    mv -f "${tofldr}/${file}" "${tofldr}/${file}${fx}"
  fi
  ln -sf "${dtfls}/${file}" "${tofldr}/${file}"
done
