#!/usr/bin/env bash

function run {
  if ! pgrep $1
  then
    $@&
  fi
}

exec compton &

pmg="${HOME}/bin/pimp-my-gui"
if [[ -x "${pmg}" ]]; then # If spice ...
  "${pmg}" & # Spice things up
fi

