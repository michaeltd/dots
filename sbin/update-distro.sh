#!/usr/bin/env /bin/bash
# Distro neutral update script tdm 171124
# DONE TODO Make this package manager dependent rather than distro dependent
# From https://en.wikipedia.org/wiki/Package_manager
# action      zypper        pacman        apt            dnf-yum            emerge
# upd repo    zypper ref 	  pacman -Sy 	  apt update     yum check-update 	emerge --sync
# upd sys     zypper up 	  pacman -Syu 	apt upgrade 	 yum update 	      emerge -uND --with-bdeps=y @world
MAIL=paperjam@localhost

set -aeou

declare -a pms=( "zypper" "pacman" "apt-get" "yum" "emerge" )

function _get-pm(){
  for pm in "${pms[@]}"; do
    temp=$( which "${pm}" )
    if [[ ! -z "${temp}" ]]; then
      echo "${temp}"
      return
    fi
  done
  # Only reason to end down here would be custom setup, alien installed
  # or otherwise system belonging to big boy who can do as well without our help.
  # So gb and thanks for all the fish. ProTip: Dont install pacman the game.
  echo "unknown"
  # return 1
}

function _update-distro(){
  case $( basename "${1}" ) in
    "${pms[0]}") "${1}" ref && "${1}" update -ly ;; # zypper DONE TODO add "assume-yes" switches here
    "${pms[1]}") "${1}" -Sy && "${1}" -Syu ;; # pacman TODO read the pacman manual, don't just take wikipedia's word for it.
    "${pms[2]}") "${1}" update && "${1}" -y upgrade ;; # apt-get DONE TODO add "assume-yes" switches here # -s for Dry run
    "${pms[3]}") "${1}" check-update && "${1}" update ;; # yum TODO read the yum manual, don't just take wikipedia's word for it.
    "${pms[4]}") "${1}" --sync && "${1}" -vuDN --nospinner --with-bdeps=y @world ;; # emerge
    *) echo -e " Nothing to be done for \"unknown\". \n Get your self a real package manager.\n Quiting." ;; # unknown TODO find something usefull to put here.
  esac
}

# Make things happen.
_update-distro "$( _get-pm )"
