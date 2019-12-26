#!/bin/bash
#
# bootstrap.bash 
# The means to migrate my .dots in new systems.

set -e

if [ "${1}" != "thoushallnotpass" ]; then
  #shellcheck disable=SC2154
  echo "${red}Read this first:${reset} ${bold}https://github.com/michaeltd/dots/blob/master/readme.md#bootstrap.sh${reset}" >&2
  exit 1
fi

# DTFLS="$(cd "$(dirname "${0}")/dot.files" && pwd -P)"
# TOFLD="${HOME}"
# FX="$(date +%s)"
# #shellcheck disable=SC2230
# LS="$(which ls)"

# for FL in $("${LS}" "-A" "${DTFLS}"); do
#   if [ -e "${TOFLD}/${FL}" ]; then
#     mv -f "${TOFLD}/${FL}" "${TOFLD}/${FL}.${FX}"
#   fi
#   ln -sf "${DTFLS}/${FL}" "${TOFLD}/${FL}"
# done

declare -A __shell=( ['.bash_logout']='dot.files/.bash_logout' \
				   ['.bash_profile']='dot.files/.bash_profile' \
				   ['.bashrc']='dot.files/.bashrc' \
				   ['.bashrc.d']='dot.files/.bashrc.d' \
				   ['.profile']='dot.files/.profile' \
				   ['.tcshrc']='dot.files/.tcshrc' \
				   ['bin']='dot.files/bin' \
				   ['sbin']='dot.files/sbin' \
				   ['.bkp.exclude']='dot.files/.bkp.exclude' )

declare -A __xorg=( ['.Xdefaults']='dot.files/.Xdefaults' \
				['.Xresources']='dot.files/.Xresources' \
				['.Xresources.d']='dot.files/.Xresources.d' \
				['.xinitrc']='.xinitrc' \
				['.xsession']='.xsession' )

declare -A __utils=( ['.gitconfig']='dot.files/.gitconfig' \
				   ['.public.pgp.key']='dot.files/.public.pgp.key' )

declare -A __wms=( ['.config/awesome']='dot.files/.config/awesome' \
				   ['.config/compiz']='dot.files/.config/compiz' \
				   ['.config/openbox']='dot.files/.config/openbox' \
				   ['.e16']='dot.files/.config/openbox' \
				   ['.fvwm']='dot.files/.fvwm' \
				   ['.fvwm-crystal']='dot.files/.fvwm-crystal' \
				   ['GNUstep']='dot.files/GNUstep' \
				   ['.mwmrc']='dot.files/.mwmrc' \
				   ['Mwm']='dot.files/Mwm' )

declare -A __security=( ['.gnupg']='dot.files/.gnupg' \
			    ['.ngrok2']='dot.files/.ngrok2' \
			    ['.ssh']='dot.files/.ssh' \
			    ['.putty']='dot.files/.putty' )

declare -A __editors=( ['.vimrc']='dot.files/.vimrc' ['.gvimrc']='dot.files/.gvimrc' )
