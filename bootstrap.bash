#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096
#
# dots/bootstrap.bash 
# Migrates my .dots in new systems.

# Unofficial Bash Strict Mode
# set -euo pipefail
# IFS=$'\t\n'

#shellcheck disable=SC2155
declare -r sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

cd "${sdn}" || exit 1

# Backup File Extension
#shellcheck disable=SC2155
declare -r bfe="dots.${sbn/.bash/}.${$}.$(date -u +%s).bkp"

#shellcheck disable=SC2034
declare -ra compton=( 'dot.files/.config/compton.conf' ) \
	tint2=( 'dot.files/.config/tint2/panel'
		'dot.files/.config/tint2/taskbar' ) \
	e16=( 'dot.files/.e16/Init/e16.sh'
	      'dot.files/.e16/bindings.cfg'
	      'dot.files/.e16/menus/user_apps.menu' ) \
	compiz=( 'dot.files/.config/compiz/compiz.sh'
		 'dot.files/.config/compiz/compizconfig/Default.ini'
		 'dot.files/.config/compiz/compizconfig/config' ) \
	i3wm=( 'dot.files/.config/i3/config'
	       'dot.files/.config/i3status/config' ) \
	x11=( 'dot.files/.Xdefaults'
	      'dot.files/.Xresources'
	      'dot.files/.Xresources.d'
	      'dot.files/.xinitrc'
	      'dot.files/.xsession' )

#shellcheck disable=SC2034
declare -ra xorg=( compton[@] tint2[@] e16[@] compiz[@] i3wm[@] x11[@] )

#shellcheck disable=SC2034
declare -ra music=( 'dot.files/.config/mpd/mpd.conf'
		    'dot.files/.config/ncmpcpp/config' ) \
	tmux=( 'dot.files/.tmux.conf' ) \
	top=( 'dot.files/.toprc' ) \
	mutt=( 'dot.files/.muttrc' ) \
	vim=( 'dot.files/.vimrc' 'dot.files/.gvimrc' ) \
	bash=( 'dot.files/.bash_logout'
	       'dot.files/.bash_profile'
	       'dot.files/.bashrc'
	       'dot.files/.profile'
	       'dot.files/.local/bin/michaeltd'
	       'dot.files/.local/bin/pimp_my_gui.bash'
	       'dot.files/.local/bin/showkb.sh'
	       'dot.files/.local/bin/sndvol'
	       'dot.files/.local/bin/term_music.bash'
	       'dot.files/.local/bin/todo_notes'
	       'dot.files/.local/bin/wallpaper_rotate.bash'
	       'dot.files/.local/bin/xlock.sh'
	       'dot.files/.local/sbin' )

#shellcheck disable=SC2034
declare -ra console=( music[@] tmux[@] top[@] mutt[@] vim[@] bash[@] )
# Build menus and help messages.
declare -ra TUI_OPS=( "quit" "help" "everything" "xorg" "console"
		      "compton" "tint2" "e16" "compiz" "i3wm" "x11"
		      "music" "tmux" "top" "mutt" "vim" "bash" )

declare -ra DESC=( "Exit this script"
		   "show this Help screen"
		   "link Everything available"
		   "link all Xorg related configs"
		   "link all Console related configs"
		   "link Compton config"
		   "link Tint2 configs" 
		   "link E16 configs" 
		   "link Compiz configs" 
		   "link i3wm and i3status configs" 
		   "link X11 rc files" 
		   "link Music mpc, mpd, npmpcpp config files" 
		   "link Tmux's tmux.conf" 
		   "link Top's toprc" 
		   "link Mutt rc" 
		   "link Gvim/Vim rc files" 
		   "link Bash related files"
)

declare -r myusage="
	Usage: ${BASH_SOURCE[0]##*/} -(-a)ll|-(-c)onsole|-(-x)org|-(-m)enu|-(-h)elp

	-(-a)ll    		 to link everything
	-(-c)onsole 		 to link console related configs
	-(-x)org 		 to link Xorg related configs
	-(-m)enu 		 to show a menu with all available options
	-(-h)elp 		 for this help message
"

is_link_set() {
    [[ -L "${HOME}${1:9}" ]] && [[ "$(realpath "${HOME}${1:9}")" == "$(realpath "${1}")" ]]
}

all_links_set() {
    eval "arr=(\"\${$1[@]}\")"
    #shellcheck disable=SC2154
    for i in "${arr[@]}"; do
	if ! is_link_set "${i}"; then
	    return 1
	fi
    done
}

no_links_set() {
    eval "arr=(\"\${$1[@]}\")"
    for i in "${arr[@]}"; do
	if is_link_set "${i}"; then
	    return 1
	fi
    done
}

check_arr() {
    eval "arr=(\"\${$1[@]}\")"
    for i in "${arr[@]}"; do
	if [[ ! -e "${i}" ]]; then
	    echo "fatal: ${i} not found"
	    return 1
	fi
    done
}

link_arr() {
    eval "arr=(\"\${$1[@]}\")"
    for i in "${arr[@]}"; do
	do_link "$(realpath "${i}")" "${HOME}${i:9}"
    done
}

check_assoc() {
    eval "assoc=(\"\${$1[@]}\")"
    for x in "${!assoc[@]}"; do
	local i=0
	while [[ -n "${!assoc[x]:i:1}" ]]; do
	    if [[ ! -e "${!assoc[x]:i:1}" ]]; then
		echo "fatal: ${!assoc[x]:i:1} not found"
		return 1
	    fi
	    (( ++i ))
	done
    done
}

link_assoc() {
    eval "assoc=(\"\${$1[@]}\")"
    for x in "${!assoc[@]}"; do
	local i=0
	while [[ -n "${!assoc[x]:i:1}" ]]; do
	    local repofile="${!assoc[x]:i:1}"
    	    local realfile="$(realpath "${repofile}")"
	    local homefile="${HOME}${repofile:9}"
	    do_link "${realfile}" "${homefile}"
	    (( ++i ))
	done
    done
}

do_link() {
    # ln force switch for directory links appears broken, so there ...
    if [[ -e "${2}" ]]; then
	mv -v "${2}" "${2}.${bfe}"
    fi
    #ln --verbose --symbolic --force --backup --suffix=".${BFE}"  "${1}" "${2}"
    mkdir -vp "$(dirname "${2}")"
    ln -vs "${1}" "${2}"
}

do_arr() {
    check_arr "${1}" || exit $?
    link_arr "${1}"
}

do_assoc() {
    check_assoc "${1}" || exit $?
    link_assoc "${1}"
}

do_everything() {
    for assoc in "console" "xorg"; do
	check_assoc "${assoc}" || exit $?
	link_assoc "${assoc}"
    done
}

menu() {

    local -a TUI_MENU=( )
    local -a TUI_HMSG=( "${myusage}" )

    for (( x = 0; x < ${#TUI_OPS[*]}; x++ )); do
        TUI_MENU+=( "${x}:${TUI_OPS[x]}" )
	(( (x + 1) % 4 == 0 )) && TUI_MENU+=( "\n" ) || TUI_MENU+=( "\t" )
        TUI_HMSG+=( "Use ${x}, which will ${DESC[x]}\n" )
    done

    while :; do

	echo -ne " ${TUI_MENU[*]}"|column -t -s $'\t'
	read -rp "Choose[0-$((${#TUI_OPS[*]}-1))]: " USRINPT

        case "${USRINPT}" in
            0) return "${?}";;
            1) echo -ne "${TUI_HMSG[*]}";;
	    2) do_"${TUI_OPS[$USRINPT]}";;
	    [3-4]) do_assoc "${TUI_OPS[$USRINPT]}";;
            [5-9]|1[0-16]) do_arr "${TUI_OPS[$USRINPT]}";;
            *) echo -ne "Invalid selection: ${USRINPT}. Choose from 0 to $((${#TUI_OPS[*]}-1))\n" >&2;;
        esac
    done
}

bootstrap() {
    case "${1}" in
	-a|--all) do_everything ;;
	-c|--console) do_assoc "console" ;;
	-x|--xorg) do_assoc "xorg" ;;
	-m|--menu) menu ;;
	*) echo -ne "${myusage}"; return 1 ;;
    esac
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && "${sbn/.bash/}" "${@}"
