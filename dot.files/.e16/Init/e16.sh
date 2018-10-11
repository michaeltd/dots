#!/usr/bin/env bash

export >> "~/e16.export.at.$(date +%s).txt" &

pmg="${HOME}/bin/pimp-my-gui.sh"
if [[ -x "${pmg}" ]]; then # If spice ...
  "${pmg}" & # Spice things up
fi
