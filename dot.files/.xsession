#!/bin/sh
#
# .xsession to source ~/.profile and execute ~/.xinitrc to sessions initiated by xdm

pf="${HOME}/.profile"
if [ -r "${pf}" ]; then # User Profile
    source "${pf}"
fi
unset pf

xirc="${HOME}/.xinitrc"
if [ -x "${xirc}" ]; then # X init rc
    "${xirc}"
fi
unset xirc
