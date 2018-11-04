#!/usr/bin/env bash

set -e

# Load explicitly for non interactive shells
source /home/paperjam/.bashrc.d/functions.sh

cd "/mnt/el/Documents/bkps/linux"

declare -a files=( $(ls -t *.tar.gz) )

printf "# clean up old backups # -------------------------------------------------------\n"

for (( x=0; x<"${#files[@]}"; x++ )); do
  if (( "x" > "1" )); then
    fn="${red}${files[$x]}${reset}"
    do="$(digits_only ${files[$x]})"
    etdt="$(epochtodatetime ${do})"
    printf "${bold}${blue}marked for removal${reset} -> %s\n" "${fn}"
    printf "%s was created at %s\n" "${fn}" "${underline}${green}${etdt}${reset}${end_underline}"
    # printf "\${#files[@]} is %s, \$x is : %s and \${files[\$x]} is \'%s\'\n" "${#files[@]}" "${x}" "${files[$x]}"
    printf "${bold}rm -v ${fn}${reset}\n"
  fi
done
