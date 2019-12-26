#!/bin/bash
#
# bootstrap.bash 
# The means to migrate my .dots in new systems.

set -e

if [[ "${1}" != "thoushallnotpass" ]]; then
    #shellcheck disable=SC2154
    echo "${red}Read this first:${reset} ${bold}https://github.com/michaeltd/dots/blob/master/readme.md#bootstrap.sh${reset}" >&2
    exit 1
else
    shift
fi

declare -A __console=( \
['.bash_logout']='dot.files/.bash_logout' \
['.bash_profile']='dot.files/.bash_profile' \
['.bashrc']='dot.files/.bashrc' \
['.bashrc.d']='dot.files/.bashrc.d' \
['.profile']='dot.files/.profile' \
['.tcshrc']='dot.files/.tcshrc' \
['bin']='dot.files/bin' \
['sbin']='dot.files/sbin' \
['.bkp.exclude']='dot.files/.bkp.exclude' \
['.vimrc']='dot.files/.vimrc' \
['.gvimrc']='dot.files/.gvimrc' \
['.muttrc']='dot.files/.muttrc' \
['.public.pgp.key']='dot.files/.public.pgp.key' \
['.tmux.conf']='dot.files/.tmux.conf' \
['.config/mpd/mpd.conf']='dot.files/.config/mpd/mpd.conf' \
['.config/ncmpcpp/config']='dot.files/.config/ncmpcpp/config')

declare -A __xorg=( \
['.Xdefaults']='dot.files/.Xdefaults' \
['.Xresources']='dot.files/.Xresources' \
['.Xresources.d']='dot.files/.Xresources.d' \
['.xinitrc']='dot.files/.xinitrc' \
['.xsession']='dot.files/.xsession' \
['.config/awesome']='dot.files/.config/awesome' \
['.config/compiz']='dot.files/.config/compiz' \
['.config/openbox']='dot.files/.config/openbox' \
['.e16']='dot.files/.config/openbox' \
['.fvwm']='dot.files/.fvwm' \
['.fvwm-crystal']='dot.files/.fvwm-crystal' \
['GNUstep']='dot.files/GNUstep' \
['.mwmrc']='dot.files/.mwmrc' \
['Mwm']='dot.files/Mwm' \
['.config/polybar']='dot.files/.config/polybar' \
['.config/tint2']='dot.files/.config/tint2' \
['.config/compton.conf']='dot.files/.config/compton.conf' \
['.config/gentoo/gentoorc']='dot.files/.config/gentoo/gentoorc' \
['.config/mc/ini']='dot.files/.config/mc/ini' \
['.config/mc/panels.ini']='dot.files/.config/mc/panels.ini' \
['.config/doublecmd/doublecmd.xml']='dot.files/.config/doublecmd/doublecmd.xml' \
['.config/doublecmd/shortcuts.scf']='dot.files/.config/doublecmd/shortcuts.scf' )

declare -A __security=( \
['.gnupg']='dot.files/.gnupg' \
['.ngrok2']='dot.files/.ngrok2' \
['.ssh']='dot.files/.ssh' \
['.putty']='dot.files/.putty' \
['.config/filezilla']='dot.files/.config/filezilla' \
['.config/hexchat']='dot.files/.config/hexchat' )

__usage(){
    echo "Usage: $(basename ${BASH_SOURCE[0]}) -(-a)ll|-(-c)onsole|-(-x)org|-(-s)ecurity|--help"
}

__check_console() {
    for i in "${!__console[@]}"; do
	if [[ ! -e "${__console[${i}]}" ]]; then
	    echo "fatal: ${__console[${i}]} not found"
	    exit 1
	fi
    done
}

__check_xorg() {
    for i in "${!__xorg[@]}"; do
	if [[ ! -e "${__xorg[${i}]}" ]]; then
	    echo "fatal: ${__xorg[${i}]} not found"
	    exit 1
	fi
    done
}

__check_security() {
    for i in "${!__security[@]}"; do
	if [[ ! -e "${__security[${i}]}" ]]; then
	    echo "fatal: ${__security[${i}]} not found"
	    exit 1
	fi
    done
}

__check_all() {
    __check_console
    __check_xorg
    __check_security
}

__do_all() {
    __check_all
}

__do_console() {
    __check_console
}

__do_xorg() {
    __check_xorg
}

__do_security() {
    __check_security
}

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

if [[ -n "${1}" ]]; then
    while [[ -n "${1}" ]]; do
    	  case ${1} in
	       -a|--all) shift; __do_all;;
	       -c|--console) shift; __do_console;;
	       -x|--xorg) shift; __do_xorg;;
	       -s|--security) shift; __do_security;;
	       *) shift; __usage; exit 1;;
	  esac
    done
else
    __usage
    exit 1
fi
