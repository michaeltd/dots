#!/usr/bin/env bash
#
# dots/bootstrap.bash 
# Migrates my .dots in new systems.

#shellcheck disable=SC2155
declare -r SDN="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	SBN="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

# No Extension Script Name
#shellcheck disable=SC2155
declare -r NESN="${SBN/\.bash/}"

#shellcheck disable=2164 #SHUT UP SHELLCHECK, MY CD'S DO NOT FAIL!!!
cd "${SDN}"

# Backup File Extension
#shellcheck disable=SC2155
declare -r BFE="dots.${NESN}.${$}.$(date +%s).bkp"

#shellcheck disable=SC2034
declare -ra compton=( 'dot.files/.config/compton.conf' ) \
	tint2=( 'dot.files/.config/tint2/panel' \
		    'dot.files/.config/tint2/taskbar' ) \
	e16=( 'dot.files/.e16/Init/e16.sh' \
		  'dot.files/.e16/bindings.cfg' \
		  'dot.files/.e16/menus/user_apps.menu' ) \
	compiz=( 'dot.files/.config/compiz/compiz.sh' \
		     'dot.files/.config/compiz/compizconfig/Default.ini' \
		     'dot.files/.config/compiz/compizconfig/config' ) \
	i3wm=( 'dot.files/.config/i3/config' \
		      'dot.files/.config/i3status/config' ) \
	x11=( 'dot.files/.Xdefaults' 'dot.files/.Xresources' \
		      'dot.files/.Xresources.d' 'dot.files/.xinitrc' \
		      'dot.files/.xsession' )

#shellcheck disable=SC2034
declare -ra xorg=( compton[@] tint2[@] e16[@] compiz[@] i3wm[@] x11[@] )

#shellcheck disable=SC2034
declare -ra music=( 'dot.files/.config/mpd/mpd.conf' \
			'dot.files/.config/ncmpcpp/config' ) \
	tmux=( 'dot.files/.tmux.conf' ) \
	top=( 'dot.files/.toprc' ) \
	mutt=( 'dot.files/.muttrc' ) \
	vim=( 'dot.files/.vimrc' 'dot.files/.gvimrc' ) \
	bash=( 'dot.files/.bash_logout' 'dot.files/.bash_profile' \
					'dot.files/.bashrc' 'dot.files/.bashrc.d' \
					'dot.files/.profile' 'dot.files/bin' 'dot.files/sbin' )

#shellcheck disable=SC2034
declare -ra console=( music[@] tmux[@] top[@] mutt[@] vim[@] bash[@] )
# Build menus and help messages.
declare -ra TUI_OPS=( "quit" "help" "everything" "xorg" "console" \
			      "compton" "tint2" "e16" "compiz" "i3wm" "x11" \
			      "music" "tmux" "top" "mutt" "vim" "bash" )

declare -ra DESC=( "Exit this script" \
		     "show this Help screen" \
		     "link Everything available" \
		     "link all Xorg related configs" \
		     "link all Console related configs" \
		     "link Compton config" \
		     "link Tint2 configs" \
		     "link E16 configs" \
		     "link Compiz configs" \
		     "link i3wm and i3status configs" \
		     "link X11 rc files" \
		     "link Music mpc, mpd, npmpcpp config files" \
		     "link Tmux's tmux.conf" \
		     "link Top's toprc" \
		     "link Mutt rc" \
		     "link Gvim/Vim rc files" \
		     "link Bash related files" \
)

declare -r usage="
 Usage: ${BASH_SOURCE[0]##*/} -(-a)ll|-(-c)onsole|-(-x)org|-(-m)enu|-(-h)elp 

 -(-a)ll    		 to link everything
 -(-c)onsole 		 to link console related configs
 -(-x)org 		 to link Xorg related configs
 -(-m)enu 		 to show a menu with all available options
 -(-h)elp 		 for this help message

"

__is_link_set() {
    [[ -L "${HOME}${1:9}" ]] && [[ "$(realpath "${HOME}${1:9}")" == "$(realpath "${1}")" ]]
}

__all_links_set() {
    eval "arr=(\"\${$1[@]}\")"
    #shellcheck disable=SC2154
    for i in "${arr[@]}"; do
	if ! __is_link_set "${i}"; then
	    return 1
	fi
    done
}

__no_links_set() {
    eval "arr=(\"\${$1[@]}\")"
    for i in "${arr[@]}"; do
	if __is_link_set "${i}"; then
	    return 1
	fi
    done
}

__check_arr() {
    eval "arr=(\"\${$1[@]}\")"
    for i in "${arr[@]}"; do
	if [[ ! -e "${i}" ]]; then
	    echo "fatal: ${i} not found"
	    return 1
	fi
    done
}

__link_arr() {
    eval "arr=(\"\${$1[@]}\")"
    for i in "${arr[@]}"; do
	__do_link "$(realpath "${i}")" "${HOME}${i:9}"
    done
}

__check_assoc() {
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

__link_assoc() {
    eval "assoc=(\"\${$1[@]}\")"
    for x in "${!assoc[@]}"; do
	local i=0
	while [[ -n "${!assoc[x]:i:1}" ]]; do
	    local repofile="${!assoc[x]:i:1}"
    	    local realfile="$(realpath "${repofile}")"
	    local homefile="${HOME}${repofile:9}"
	    __do_link "${realfile}" "${homefile}"
	    (( ++i ))
	done
    done
}

__do_link() {
    # ln force switch for directory links appears broken, so there ...
    if [[ -e "${2}" ]]; then
	$(type -P mv) -v "${2}" "${2}.${BFE}"
    fi
    #ln --verbose --symbolic --force --backup --suffix=".${BFE}"  "${1}" "${2}"
    $(type -P mkdir) -vp "$(dirname "${2}")"
    $(type -P ln) -vs "${1}" "${2}"
}

__do_arr() {
    __check_arr "${1}" || exit $?
    __link_arr "${1}"
}

__do_assoc() {
    __check_assoc "${1}" || exit $?
    __link_assoc "${1}"
}

__do_everything() {
    for assoc in "console" "xorg"; do
	__check_assoc "${assoc}" || exit $?
	__link_assoc "${assoc}"
    done
}

__menu() {

    local -a TUI_MENU=( )
    local -a TUI_HMSG=( "${usage}" )

    for (( x = 0; x < ${#TUI_OPS[*]}; x++ )); do
        TUI_MENU+=( "${x}:${TUI_OPS[x]}" )
	(( (x + 1) % 4 == 0 )) && TUI_MENU+=( "\n" ) || TUI_MENU+=( "\t" )
        TUI_HMSG+=( "Use ${x}, which will ${DESC[x]}\n" )
    done

    while :; do

	echo -ne " ${TUI_MENU[*]}"|column -t -s $'\t'
	read -rp "Choose[0-$((${#TUI_OPS[*]}-1))]: " USRINPT

        case "${USRINPT}" in
            0) exit;;
            1) echo -ne "${TUI_HMSG[*]}";;
	    2) __do_"${TUI_OPS[$USRINPT]}";;
	    [3-4]) __do_assoc "${TUI_OPS[$USRINPT]}";;
            [5-9]|1[0-16]) __do_arr "${TUI_OPS[$USRINPT]}";;
            *) echo -ne "Invalid selection: ${USRINPT}. Choose from 0 to $((${#TUI_OPS[*]}-1))\n" >&2;;
        esac
    done
}

__main() {
    case "${1}" in
	-a|--all) __do_everything ;;
	-c|--console) __do_assoc "console" ;;
	-x|--xorg) __do_assoc "xorg" ;;
	-m|--menu) __menu ;;
	*) echo -ne "\n${usage}\n"; exit 1 ;;
    esac
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && __main "${@}"
