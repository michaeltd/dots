#!/usr/bin/env /bin/bash
# Distro neutral update script tdm 171124
# From https://en.wikipedia.org/wiki/Package_manager
MAIL=paperjam@localhost

set -au # set -e is out

declare -a zypper=("zypper" "ref" "update" "-ly"); declare -a pacman=("pacman" "-Sy" "-Syu"); declare -a apt_get=("apt-get" "update" "-ys" "upgrade"); declare -a yum=("yum" "check-update" "update"); declare -a emerge=("emerge" "--sync" "-vuDN" "--nospinner" "--with-bdeps=y" "@world");
declare -a pms=(zypper[@] pacman[@] apt_get[@] yum[@] emerge[@])

function _get_pm(){
  for x in "${!pms[@]}"; do
    temp=$( which "${!pms[$x]:0:1}" )
    if [[ ! -z "${temp}" ]]; then
      echo "${x}"
      return # return on match.
    fi
  done
  echo "999" # No valid package manager found. quit
}

function _get_upd_opts_no() {
  cnt=0; idx=2
  while [[ ! -z ${!pms[$1]:$idx:1} ]]; do
   (( cnt++, idx++ ))
  done
  echo $cnt
}

function _update_distro() {
  if [[ "${1}" -eq "999" ]]; then
    echo -e " Nothing to be done for \"unknown\" package manager. \n Quithing.\n"
  else
    "${!pms[$1]:0:1}" "${!pms[$1]:1:1}" && "${!pms[$1]:0:1}" "${!pms[$1]:2:$( _get_upd_opts_no ${1} )}"
  fi
}

# Make things happen.
_update_distro "$( _get_pm )"
