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
declare -ra bash=( 'dot.files/.bash_logout' \
		      'dot.files/.bash_profile' \
		      'dot.files/.bashrc' \
		      'dot.files/.bashrc.d' \
		      'dot.files/.profile' \
		      'dot.files/bin' \
		      'dot.files/sbin' ) \
	vim=( 'dot.files/.vimrc' 'dot.files/.gvimrc' ) \
	mutt=( 'dot.files/.muttrc' ) \
	top=( 'dot.files/.toprc' ) \
	tmux=( 'dot.files/.tmux.conf' ) \
	music=( 'dot.files/.config/mpd/mpd.conf' \
		    'dot.files/.config/ncmpcpp/config' \
		    'dot.files/.moc/config' \
		    'dot.files/.moc/keymap' )
#shellcheck disable=SC2034
declare -ra console=( bash[@] vim[@] mutt[@] top[@] tmux[@] music[@] )
#shellcheck disable=SC2034
declare -ra x11=( 'dot.files/.Xdefaults' \
		      'dot.files/.Xresources' \
		      'dot.files/.Xresources.d' \
		      'dot.files/.xinitrc' \
		      'dot.files/.xsession' ) \
	awesome=( 'dot.files/.config/awesome/autorun.sh' \
		      'dot.files/.config/awesome/rc.lua' ) \
	compiz=( 'dot.files/.config/compiz/compiz.sh' \
		     'dot.files/.config/compiz/compizconfig/Default.ini' \
		     'dot.files/.config/compiz/compizconfig/config' ) \
	openbox=( 'dot.files/.config/openbox/autostart' \
		      'dot.files/.config/openbox/environment' \
		      'dot.files/.config/openbox/menu.xml' \
		      'dot.files/.config/openbox/rc.xml' \
		      'dot.files/.config/openbox/scripts/date_menu.sh' \
		      'dot.files/.config/openbox/scripts/obam.pl' ) \
	e16=( 'dot.files/.e16/Init/e16.sh' \
		  'dot.files/.e16/bindings.cfg' \
		  'dot.files/.e16/menus/user_apps.menu' ) \
	gnustep=( 'dot.files/GNUstep/Defaults/WindowMaker' \
		      'dot.files/GNUstep/Defaults/WMRootMenu' \
		      'dot.files/GNUstep/Library/WindowMaker/autostart' \
		      'dot.files/GNUstep/Library/WindowMaker/exitscript' ) \
	mwm=( 'dot.files/.mwmrc' 'dot.files/Mwm' ) \
	polybar=( 'dot.files/.config/polybar/config' \
		      'dot.files/.config/polybar/launch.sh' ) \
	tint2=( 'dot.files/.config/tint2/panel' \
		    'dot.files/.config/tint2/taskbar' ) \
	compton=( 'dot.files/.config/compton.conf' )
#shellcheck disable=SC2034
declare -ra xorg=( x11[@] awesome[@] compiz[@] openbox[@] e16[@] \
		      gnustep[@] mwm[@] polybar[@] tint2[@] compton[@] )

declare -r usage="Usage: $(basename "${BASH_SOURCE[0]}") -(-a)ll|-(-c)onsole|-(-x)org|-(-m)enu|-(-h)elp"

__is_link_set() {
    local -r homefile="${HOME}${1:9}"
    local -r realfile="$(realpath "${1}")"
    [[ -L "${homefile}" ]] && [[ "$(realpath "${homefile}")" == "${realfile}" ]]
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
	local realfile="$(realpath "${i}")" homefile="${HOME}${i:9}"
	__do_link "${realfile}" "${homefile}"
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
    # Build menus and help messages.
    local -ra TUI_OPS=( "bash" "vim" "mutt" "tmux" "top" "music" "x11" \
			      "awesome" "compiz" "openbox" "e16" "gnustep" \
			      "mwm" "polybar" "tint2" "compton" "console" \
			      "xorg" "everything" "help" "quit" )

    local -ra SDESC=( "Bash" "Vim/Gvim" "Mutt" "Tmux" "Top" "Music" "X11" \
			    "Awesome" "Compiz" "OpenBox" "E16" "GNUstep" \
			    "Mwm" "Polybar" "Tint2" "Compton" "Console" \
			    "Xorg" "Everything" "Help" "Quit" )

    local -ra DESC=( "link ${SDESC[0]} related files" \
			"link ${SDESC[1]} rc files" \
			"link ${SDESC[2]} rc" \
			"link ${SDESC[3]}'s tmux.conf" \
			"link ${SDESC[4]}'s toprc" \
			"link ${SDESC[5]} mpd, npmpcpp, mocp config files" \
			"link ${SDESC[6]} rc files" \
			"link ${SDESC[7]} config and autostart files" \
			"link ${SDESC[8]} configs" \
			"link ${SDESC[9]} xml and scripts" \
			"link ${SDESC[10]} configs" \
			"link ${SDESC[11]} WindowMaker files" \
			"link ${SDESC[12]} Motif Window Manager configs" \
			"link ${SDESC[13]} config" \
			"link ${SDESC[14]} files" \
			"link ${SDESC[15]} config" \
			"link all ${SDESC[16]} related configs" \
			"link all ${SDESC[17]} related configs" \
			"link ${SDESC[18]}" \
			"show this ${SDESC[19]} screen" \
			"${SDESC[20]} this script" )

    local -a TUI_MENU=( )
    local -a TUI_HMSG=( "${usage}\n" )

    for (( x = 0; x < ${#TUI_OPS[*]}; x++ )); do
        TUI_MENU+=( "${x}:${TUI_OPS[x]}" )
	(( x > 0 && x % 5 == 0 )) && TUI_MENU+=( "\n" ) || TUI_MENU+=( "\t" )
        TUI_HMSG+=( "Use ${x}, for ${SDESC[x]}, which will ${DESC[x]}\n" )
    done

    TUI_MENU+=( "Choose[0-$((${#TUI_OPS[@]}-1))]:" )

    while :; do
        echo -ne " ${TUI_MENU[*]}"
        read -r USRINPT

        case "${USRINPT}" in
	    # Thanks to https://www.reddit.com/user/Schreq/
            [0-9]|1[0-5]) __do_arr "${TUI_OPS[$USRINPT]}";;
	    1[6-7]) __do_assoc "${TUI_OPS[$USRINPT]}";;
	    18) __do_"${TUI_OPS[$USRINPT]}";;
            19) echo -ne "${TUI_HMSG[*]}";;
            20) exit;;
            *) echo -ne "Invalid responce: ${USRINPT}. Choose from 0 to $((${#TUI_OPS[*]}-1))\n" >&2;;
        esac
    done
}

__main() {
    if [[ -n "${1}" ]]; then
	while [[ -n "${1}" ]]; do
    	    case "${1}" in
		"a"|"-a"|"--all") shift; __do_everything ;;
		"c"|"-c"|"--console") shift; __do_assoc "console" ;;
		"x"|"-x"|"--xorg") shift; __do_assoc "xorg" ;;
		"m"|"-m"|"--menu") shift; __menu ;;
		*) shift; echo "${usage}"; exit 1 ;;
	    esac
	done
    else
	echo "${usage}"
	exit 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    __main "${@}"
fi
