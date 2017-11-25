#!/usr/bin/env /bin/bash
# Distro neutral update script tdm 171124
# From https://en.wikipedia.org/wiki/Package_manager
# action      zypper        pacman        apt            dnf-yum            emerge
# upd repo    zypper ref 	  pacman -Sy 	  apt update     yum check-update 	emerge --sync
# upd sys     zypper up 	  pacman -Syu 	apt upgrade 	 yum update 	      emerge -uND --with-bdeps=y @world
MAIL=paperjam@localhost

set -aeou

function update-gentoo() {
  emerge --sync
  emerge -vuDN --nospinner @world
}

function update-opensuse() {
  # TODO add "assume-yes" switches here
  zypper update -ly # -l, --auto-agree-with-licenses / -y, --no-confirm
}

function update-debian() {
  # TODO add "assume-yes" switches here
  apt-get update
  #apt-get -ys upgrade # Dry run
  apt-get -y upgrade # Wet run
}

function update-ubuntu() {
  update-debian
}

function update-mint() {
  update-debian
}

function update-devuan() {
  update-debian
}

function update-unknown() {
  # TODO find something usefull to put here.
  echo "Nothing to be done for \"unknown\". Quiting."
}

function get-distro() {
  dists=( "gentoo" "opensuse" "debian" "ubuntu" "mint" "devuan" )
  for dist in "${dists[@]}"; do
    uname -a|grep $dist >> /dev/null # echo'ing stuff can ruin this
    ret=$?
    if [[ $ret -eq 0 ]]; then
      echo $dist
      return 0 # Quit function on match.
    fi
  done
  echo "unknown"
  # return 1 # As quit on error is in effect ("set -e") it would be wise not to raise one. (lolz?)
}

# Make things happen.
update-"$( get-distro )"
