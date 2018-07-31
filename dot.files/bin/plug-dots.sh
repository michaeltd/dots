#!/usr/bin/env bash
#
# ~/bin/plug-dots.sh
# The means to migrate my .dots in new systems.

# function runme() {
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
# }

# function dbg() {
#   ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
#   echo " ABSOLUTE_PATH is" $ABSOLUTE_PATH
#   echo " BASH_SOURCE 0 is" ${BASH_SOURCE[0]}
#   echo " basename BASH_SOURCE 0 is" $( basename "${BASH_SOURCE[0]}" )
#   echo " dirname BASH_SOURCE 0 is" $( dirname "${BASH_SOURCE[0]}" )
#   echo " cd dirname BASH_SOURCE 0 pwd is" $(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
#   dtfls="$(cd ../$(dirname ${BASH_SOURCE[0]}) && pwd)" # One down from this one (bin/plug-dots.sh)
#   echo " dtfls is" $dtfls
# }

# dbg
