#!/usr/bin/env bash

dtfls="${HOME}/git/lib-bash/dot.files"
tofldr="${HOME}"
fx=".${RANDOM}"
ls=$(which ls) # alias workaround
declare -a fls=( $(${ls} -A ${dtfls}) )

for file in ${fls[@]}; do
  if [[ -L "${tofldr}/${file}" || -d "${tofldr}/${file}" || -f "${tofldr}/${file}" ]]; then
    mv -f "${tofldr}/${file}" "${tofldr}/${file}${fx}"
  fi
  ln -s "${dtfls}/${file}" "${tofldr}/${file}"
done
