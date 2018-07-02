#!/usr/bin/env bash
# .xsession to loads ~/.profile and ~/.xinit to sessions initiated my xdm's

pf="${HOME}/.profile"
if [[ -r "${pf}" ]]; then # User Profile
  source "${pf}"
fi

xirc="${HOME}/.xinitrc"
if [[ -x "${xirc}" ]]; then # X init rc
  "${xirc}"
fi
