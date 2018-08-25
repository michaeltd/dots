#!/usr/bin/env bash
#
# ~/bin/plug-dots.sh
# The means to migrate my .dots in new systems.

function doExeptions {
    # awesome
    as=""
    at=""
    # openbox
    os=""
    ot=""
    # tint2
    ts=""
    tt=""

    return
}

# dtfls="${HOME}/git/lib-bash/dot.files"
dtfls="$(cd ../$(dirname ${BASH_SOURCE[0]}) && pwd)" # One down from this one (bin/plug-dots.sh)

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

doExeptions
