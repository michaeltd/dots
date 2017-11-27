#!/usr/bin/env /bin/bash
# Distro neutral update script tdm 171124
# From https://en.wikipedia.org/wiki/Package_manager
MAIL=paperjam@localhost
set -au # set -e is out as is -o as we're done debuging.
declare -a zypper=("zypper" "ref" "update" "-ly"); # -l, --license and -y, --yes for non interactive scripts
declare -a pacman=("pacman" "-Sy" "-Syu"); # TODO RTFM
declare -a apt_get=("apt-get" "update" "-ys" "upgrade"); # -y, --yes for non interactive scripts -s, --symulate for testing purposes
declare -a yum=("yum" "check-update" "update"); # TODO RTFM
declare -a emerge=("emerge" "--sync" "-vuDN" "--nospinner" "--with-bdeps=y" "@world");
declare -a pms=(zypper[@] pacman[@] apt_get[@] yum[@] emerge[@]);

function _get_pm_(){
  for x in "${!pms[@]}"; do
    temp=$( which "${!pms[$x]:0:1}" )
    if [[ ! -z "${temp}" ]]; then
      printf "%d\n" "${x}" # return found package manager index
      return # quit on match.
    fi
  done
  printf "%d\n" "254" # No known package manager found. quit
}

function _get_upd_opts_no_() {
  idx=2; cnt=0
  while [[ ! -z ${!pms[$1]:$idx:1} ]]; do
    (( idx++, cnt++ ))
  done
  printf "%d\n" "${cnt}" # Return arguments count
}

function _update_distro_() {
  if [[ "${1}" -eq "254" ]]; then
    printf " Nothing to be done for \"unknown\" package manager. \n For this to work you need a zypper, pacman, apt, yum or portage based distro. \n Quithing.\n"
  else
    "${!pms[$1]:0:1}" "${!pms[$1]:1:1}" && "${!pms[$1]:0:1}" "${!pms[$1]:2:$( _get_upd_opts_no_ ${1} )}"
  fi
}

# Make things happen.
_update_distro_ "$( _get_pm_ )"
