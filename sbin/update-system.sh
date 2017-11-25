#!/usr/bin/env /bin/bash
# Distro neutral update script tdm 171124
# TODO --Make this package manager dependent rather than distro dependent--
# From https://en.wikipedia.org/wiki/Package_manager
# action      zypper        pacman        apt            dnf-yum            emerge
# upd repo    zypper ref 	  pacman -Sy 	  apt update     yum check-update 	emerge --sync
# upd sys     zypper up 	  pacman -Syu 	apt upgrade 	 yum update 	      emerge -uND --with-bdeps=y @world
MAIL=paperjam@localhost

set -aou #e

declare zypper=$( which zypper )
declare pacman=$( which pacman )
declare apt-get=$( which apt-get )
declare yum=$( which yum )
declare emerge=$( which emerge )

function update-zypper() {
  # TODO add "assume-yes" switches here
  zypper update -ly # -l, --auto-agree-with-licenses / -y, --no-confirm
}

function update-pacman() {
  # TODO read the pacman manual, don't just take wikipedia's word for it.
  pacman -Sy
  pacman -Syu
}

function update-apt-get() {
  # TODO add "assume-yes" switches here
  apt-get update
  # apt-get -ys upgrade # Dry run
  apt-get -y upgrade # Wet run
}

function update-yum() {
  # TODO read the yum manual, don't just take wikipedia's word for it.
  yum check-update
  yum update
}

function update-emerge() {
  emerge --sync
  emerge -vuDN --nospinner --with-bdeps=y @world
}

function update-unknown() {
  # TODO find something usefull to put here.
  echo -e " Nothing to be done for \"unknown\". \n Get your self a real package manager \n or uninstall pacman the game \n Quiting."
}

function get-distro() {
  # defunct, kept for reference.
  dists=( "gentoo" "opensuse" "debian" "ubuntu" "devuan" )
  for dist in "${dists[@]}"; do
    uname -a|grep $dist >> /dev/null # echo'ing stuff can ruin this
    ret=$?
    if [[ $ret -eq 0 ]]; then
      echo $dist
      return 0 # Quit function on match.
    fi
  done
  echo "unknown"
  return 1
}

function get-package-manager(){

  if [[ ! -z "${zypper}" && -z "${pacman}" && -z "${apt-get}" && -z "${yum}" && -z "${emerge}" ]]; then
    echo "zypper"
    return 0
  elif [[ -z "${zypper}" && ! -z "${pacman}" && -z "${apt-get}" && -z "${yum}" && -z "${emerge}" ]]; then
    echo "pacman"
    return 0
  elif [[ -z "${zypper}" && -z "${pacman}" && ! -z "${apt-get}" && -z "${yum}" && -z "${emerge}" ]]; then
    echo "apt-get"
    return 0
  elif [[ -z "${zypper}" && -z "${pacman}" && -z "${apt-get}" && ! -z "${yum}" && -z "${emerge}" ]]; then
    echo "yum"
    return 0
  elif [[ -z "${zypper}" && -z "${pacman}" && -z "${apt-get}" && -z "${yum}" && ! -z "${emerge}" ]]; then
    echo "emerge"
    return 0
  else
    # Only reason to reach final clause would be custom setup, alien installed
    # or otherwise system belonging to big boy who can do as well without our help.
    # So gb and thanks for all the fish.
    # ProTip: Don't install pacman the game.
    echo "unknown"
    return 1
  fi
}

# Make things happen.
update-"$( get-package-manager )"
