#!/usr/bin/env bash

pmg="${HOME}/bin/pimp-my-gui"
if [[ -x "${pmg}" ]]; then # If spice ...
  "${pmg}" & # Spice things up
fi
