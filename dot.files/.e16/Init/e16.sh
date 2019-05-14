#!/usr/bin/env bash

PMG="${HOME}/bin/pimp-my-gui.sh"
if [[ -x "${PMG}" ]]; then # If spice ...
  "${PMG}" & # Spice things up
fi
