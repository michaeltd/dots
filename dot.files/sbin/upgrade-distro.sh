#!/usr/bin/env bash
#
# ~/sbin/upgrade-distro.sh
# Distro neutral upgrade script tdm 171124
# From https://en.wikipedia.org/wiki/Package_manager

# For this to work package manager arrays must be in following format...
# | #1 package manager executable | #2 repo update switch | #3 distro upgrade switch(es)| #4 ...
# PS: By ignoring dpkg and rpm we are avoiding issues with systems where alien has been installed.
declare -a zypper=( "zypper" "refresh" "update" "--no-confirm" "--auto-agree-with-licenses" ) pacman=( "pacman" "-Sy" "-Syu" ) apt_get=( "apt-get" "update" "--assume-yes" "--simulate" "dist-upgrade" ) yum=( "yum" "check-update" "update" ) emerge=( "emerge" "--sync" "--nospinner" "--pretend" "--update" "--deep" "--newuse" "--with-bdeps=y" "@world" ) pms=( zypper[@] pacman[@] apt_get[@] yum[@] emerge[@] ) notfound="254" pmidx="${notfound}"

# Which is the first available pm in this system?
for x in "${!pms[@]}"; do
  if [[ -n $(which "${!pms[$x]:0:1}" 2> /dev/null) ]]; then
    pmidx="${x}"
    break # break on first match.
  fi
done

if (( "${pmidx}" == "${notfound}" )); then
  printf "${red}Error:${reset} ${bold}Package manager not found.${reset}\n Nothing to be done for \"unknown\" package manager.\n For this to work you need a \n ${underline}${green}%s${reset}${end_underline}, \n ${underline}${green}%s${reset}${end_underline}, \n ${underline}${green}%s${reset}${end_underline}, \n ${underline}${green}%s${reset}${end_underline} or \n ${underline}${green}%s${reset}${end_underline} based distro.\n Quithing.\n" "${!pms[0]:0:1}" "${!pms[1]:0:1}" "${!pms[2]:0:1}" "${!pms[3]:0:1}" "${!pms[4]:0:1}"
  return 1
else
  printf "# UPDATE-UPGRADE # -------------------------------------------------------------\n"
  "${!pms[${pmidx}]:0:1}" "${!pms[${pmidx}]:1:1}" && "${!pms[${pmidx}]:0:1}" "${!pms[${pmidx}]:2}"
fi
