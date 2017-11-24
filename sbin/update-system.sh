#!/usr/bin/env /bin/bash
MAIL=paperjam@localhost

set -aoue

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

function update-devuan() {
  update-debian
}

function update-unknown() {
  # TODO find something usefull to put here.
  echo "Nothing to do for \"unknown\". Quiting."
}

function get-distro() {
  dists=( "gentoo" "opensuse" "debian" "devuan" )
  for dist in "${dists[@]}"; do
    uname -a|grep $dist >> /dev/null # echo'ing stuff can ruin this
    ret=$?
    if [[ $ret -eq 0 ]]; then
      echo $dist
      return 0
    fi
  done
  echo "unknown"
  return 1
}

# Make things happen.
update-"$( get-distro )"
