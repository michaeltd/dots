#!/usr/bin/env bash

set -e

# Load explicitly for non interactive shells
source /home/paperjam/.bashrc.d/functions.sh

cd "/mnt/el/Documents/bkps/linux"

declare -a files=( $(ls -t *.tar.gz) )

printf "# clean up old backups # -------------------------------------------------------\n"

for (( x=0; x<"${#files[@]}"; x++ )); do
  if (( "x" > "1" )); then
    fn="${files[$x]}"
    pfn="${red}${fn}${reset}"
    do="$(digits_only ${fn})"
    etdt="$(epochtodatetime ${do})"
    printf "${bold}${blue}marked for removal${reset} -> %s\n" "${pfn}"
    printf "%s was created at %s\n" "${pfn}" "${underline}${green}${etdt}${reset}${end_underline}"
    printf "${bold}rm -v %s${reset}\n" "${pfn}"
    rm -v "${fn}"
  fi
done
