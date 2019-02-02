#!/usr/bin/env bash
#
# ~/sbin/upgrade-distro.sh
# Distro neutral upgrade script tdm 171124
# From https://en.wikipedia.org/wiki/Package_manager

# For this to work package manager arrays must be in following format...
# | #1 package manager executable | #2 repo update switch | #3 distro upgrade switch(es)| #4 ...
# PS: By ignoring dpkg and rpm we are avoiding issues with systems where alien has been installed.
declare -a zypper=( "zypper" "refresh" "update" "--no-confirm" "--auto-agree-with-licenses" )
declare -a pacman=( "pacman" "-Sy" "-Syu" )
declare -a apt_get=( "apt-get" "update" "--assume-yes" "--simulate" "dist-upgrade" )
declare -a yum=( "yum" "check-update" "update" )
declare -a emerge=( "emerge" "--sync" "--nospinner" "--pretend" "--update" "--deep" "--newuse" "--with-bdeps=y" "@world" )
declare -a pms=( zypper[@] pacman[@] apt_get[@] yum[@] emerge[@] )
declare notfound="254"
declare pmidx="${notfound}"

# Which is the first available pm in this system?
for x in "${!pms[@]}"; do
  if [[ -n $(which "${!pms[$x]:0:1}" 2> /dev/null) ]]; then
    pmidx="${x}"
    break # break on first match.
  fi
done

if (( pmidx == notfound || EUID != 0 )); then
  printf "${red}Error:${reset} ${bold}Package manager not found, or non root privilages.${reset}\n For this to work you need ${underline}${green}root${reset}${end_underline} account privilages and a \n ${underline}${green}%s${reset}${end_underline}, ${underline}${green}%s${reset}${end_underline}, ${underline}${green}%s${reset}${end_underline}, ${underline}${green}%s${reset}${end_underline} or ${underline}${green}%s${reset}${end_underline} based distro.\n Quithing.\n" "${!pms[0]:0:1}" "${!pms[1]:0:1}" "${!pms[2]:0:1}" "${!pms[3]:0:1}" "${!pms[4]:0:1}"
  exit 1
else
  printf "# UPDATE-UPGRADE # -------------------------------------------------------------\n"
  "${!pms[${pmidx}]:0:1}" "${!pms[${pmidx}]:1:1}" && "${!pms[${pmidx}]:0:1}" "${!pms[${pmidx}]:2}"
fi
