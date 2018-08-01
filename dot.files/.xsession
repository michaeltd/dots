#!/usr/bin/env bash
#
# .xsession to sorce ~/.profile and execute ~/.xinitrc to sessions initiated by xdm

pf="${HOME}/.profile"
if [[ -r "${pf}" ]]; then # User Profile
  source "${pf}"
fi

xirc="${HOME}/.xinitrc"
if [[ -x "${xirc}" ]]; then # X init rc
  "${xirc}"
fi
