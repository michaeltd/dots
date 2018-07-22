#!/usr/bin/env bash
# upgrade-distro.sh: Distro neutral upgrade script tdm 171124
# From https://en.wikipedia.org/wiki/Package_manager

# For this to work package manager arrays must be in following format...
# | #1 package manager executable | #2 repo update switch | #3 distro upgrade switch(es)| #4 ...
declare -a zypper=( "zypper" "refresh" "update" "--no-confirm" "--auto-agree-with-licenses" ) pacman=( "pacman" "-Sy" "-Syu" ) apt_get=( "apt-get" "update" "--assume-yes" "--simulate" "dist-upgrade" ) yum=( "yum" "check-update" "update" ) emerge=( "emerge" "--sync" "--nospinner" "--pretend" "--update" "--deep" "--newuse" "--with-bdeps=y" "@world" ) pms=( zypper[@] pacman[@] apt_get[@] yum[@] emerge[@] )
# PS: By ignoring dpkg and rpm we are avoiding issues with systems where alien has been installed.

function _get_pm(){ # Which is the first available pm in this system?
  for x in "${!pms[@]}"; do
    if [[ -n $(which "${!pms[$x]:0:1}" 2> /dev/null) ]]; then
      printf "%d\n" "${x}" # return pm index
      return # quit on match.
    fi
  done
  printf "%d\n" "254" # No known pm found. quit
}

function _upgrade_distro() {
  if [[ "${1}" -eq "254" ]]; then
    printf " Nothing to be done for \"unknown\" package manager.\n For this to work you need a zypper, pacman, apt, yum or portage based distro.\n Quithing.\n"
  else
    printf "# UPDATE-UPGRADE # -------------------------------------------------------------\n"
    "${!pms[$1]:0:1}" "${!pms[$1]:1:1}" && "${!pms[$1]:0:1}" "${!pms[$1]:2}"
  fi
}

_upgrade_distro "$( _get_pm )" # Make things happen.
