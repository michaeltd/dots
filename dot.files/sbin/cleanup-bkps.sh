#!/usr/bin/env bash

set -e

# Load explicitly for non interactive shells
source /home/paperjam/.bashrc.d/time.sh

cd "/mnt/el/Documents/BKP/LINUX"

# old system archives
declare -a files=( $(ls -t *.sys.tar.gz.asc) ) # Sorting by mod time "-t", so no LC_LOCALE change required

for (( x=0; x<"${#files[@]}"; x++ )); do
  if (( x > 6 )); then
    fn="${files[$x]}"
    pfn="${red}${fn}${reset}"
    dp="${fn:0:10}"
    etdt="$(epochtodatetime ${dp})"
    printf "${bold}${blue}marked for removal${reset} -> %s\n" "${pfn}"
    printf "%s was created at %s\n" "${pfn}" "${underline}${green}${etdt}${reset}${end_underline}"
    printf "${bold}rm -v %s${reset}\n" "${pfn}"
    rm -v "${fn}"
  fi
done

# new user encrypted archives
declare -a files=( $(ls -t *.usr.tar.gz.asc) ) # Sorting by mod time "-t", so no LC_LOCALE change required

for (( x=0; x<"${#files[@]}"; x++ )); do
  if (( x > 6 )); then
    fn="${files[$x]}"
    pfn="${red}${fn}${reset}"
    dp="${fn:0:10}"
    etdt="$(epochtodatetime ${dp})"
    printf "${bold}${blue}marked for removal${reset} -> %s\n" "${pfn}"
    printf "%s was created at %s\n" "${pfn}" "${underline}${green}${etdt}${reset}${end_underline}"
    printf "${bold}rm -v %s${reset}\n" "${pfn}"
    rm -v "${fn}"
  fi
done
