#!/bin/bash
#
# ~/sbin/upgrade_distro.sh
# Distro neutral upgrade script michaeltd 171124
# From https://en.wikipedia.org/wiki/Package_manager

# For this to work package manager arrays must be in following format...
# | #1 package manager executable | #2 repo update switch | #3 distro upgrade switch(es)| #4 ...
# PS: By ignoring dpkg and rpm we are avoiding issues with systems where alien has been installed.
#shellcheck disable=SC2034
declare -a ZYPPER=( "zypper" "refresh" "update" "--no-confirm" "--auto-agree-with-licenses" ) PACMAN=( "pacman" "-Sy" "-Syu" ) APT_GET=( "apt-get" "update" "--assume-yes" "--simulate" "dist-upgrade" ) YUM=( "yum" "check-update" "update" ) EMERGE=( "emerge" "--sync" "--pretend" "--nospinner" "--update" "--deep" "--newuse" "${1:-@security}" )

declare -a PMS=( ZYPPER[@] PACMAN[@] APT_GET[@] YUM[@] EMERGE[@] )

declare NOTFOUND="404"

declare PMIDX="${NOTFOUND}"

# Which is the first available pm in this system?
for x in "${!PMS[@]}"; do
  if [[ -n $(command -v "${!PMS[$x]:0:1}" 2> /dev/null) ]]; then
    PMIDX="${x}"
    break # break on first match.
  fi
done

printf " -- %s --\n" "$(basename "${BASH_SOURCE[0]}")"

if (( PMIDX == NOTFOUND || EUID != 0 )); then
  #shellcheck disable=SC2154
  echo -ne "${red}Error:${reset} ${bold}Package manager not found, or non root privilages.${reset}\n For this to work you need ${underline}${green}root${reset}${end_underline} account privilages and a \n ${underline}${green}%s${reset}${end_underline}, ${underline}${green}%s${reset}${end_underline}, ${underline}${green}%s${reset}${end_underline}, ${underline}${green}%s${reset}${end_underline} or ${underline}${green}%s${reset}${end_underline} based distro.\n Quithing.\n" "${!PMS[0]:0:1}" "${!PMS[1]:0:1}" "${!PMS[2]:0:1}" "${!PMS[3]:0:1}" "${!PMS[4]:0:1}" >&2
  exit 1
else
  time "${!PMS[${PMIDX}]:0:1}" "${!PMS[${PMIDX}]:1:1}" && time "${!PMS[${PMIDX}]:0:1}" "${!PMS[${PMIDX}]:2}"
fi
