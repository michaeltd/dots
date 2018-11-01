#!/usr/bin/env bash

set -e

# Load explicitly for non interactive shells
source /home/paperjam/.bashrc.d/functions.sh

cd "/mnt/el/Documents/bkps/linux"

declare -a files=($(ls -t *.tar.gz))

printf "# clean up old backups # -------------------------------------------------------\n"

for (( x=0; x<"${#files[@]}"; x++ )); do
  if (( "x" > "1" )); then
    fn="${files[$x]}"
    do="$(digits_only ${fn})"
    etdt="$(epochtodatetime ${do})"
    printf "marked for removal -> %s\n" "${fn}"
    printf "%s was created at %s\n" "${fn}" "${etdt}"
    # printf "\${#files[@]} is %s, \$x is : %s and \${files[\$x]} is \'%s\'\n" "${#files[@]}" "${x}" "${files[$x]}"
    printf "rm -v ${fn}\n"
  fi
done
