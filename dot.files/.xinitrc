# ~/.xinitrc
#
# Or: "The dedicated WM hoppers ~/.xinitrc"

# ~/.Xresources
xrdb -I"${HOME}" -merge ~/.Xresources

# Silence terminal bell
xset b off

# Mouse acceleration
xset m 20/10 4

# Qt5 theme engine
export QT_QPA_PLATFORMTHEME=qt5ct

declare openbox="openbox-session" windowmaker="wmaker" jwm="jwm" awesome="awesome" mwm="mwm" crystal="fvwm-crystal" fvwm="fvwm" e16="starte16" enlightenment="enlightenment_start" xfce4="xfce4-session" compiz="compiz" emacs="emacs" kodi="kodi-standalone"

#                0       1           2   3       4   5       6    7   8             9     10     11    12
declare -a WMA=( openbox windowmaker jwm awesome mwm crystal fvwm e16 enlightenment xfce4 compiz emacs kodi )

# Per distro selection. If you've got preferences for specific distros, set them up here.
source /etc/os-release
if [[ "${ID}" == "devuan" ]]; then
    WM="${!WMA[9]}"
elif [[ "${ID}" == "gentoo" ]]; then
    WM="${!WMA[3]}"
else
    # Availability check
    #
    # One line version.
    # WM=$(which openbox-session||which wmaker||which jwm||which awesome||which mwm||which fvwm-crystal||which fvwm||which starte16||which enlightenment_start||which xfce4-session||which compiz||which emacs||which kodi-standalone)
    for x in "${WMA[@]}"; do
        if [[ -x "$(which ${!x} 2> /dev/null)" ]]; then
            WM="${!x}"
            break
        fi
    done
fi

# Arguments check. If startx has an argument (eg: xfce4), set it up.
for x in ${@}; do
    for y in ${WMA[@]}; do
        if [[ "${x}" =~ "${y}" ]]; then
            WM="${!y}"
        fi
    done
done

# Per wm customizations. If there is a wm specific permutation to be done, here is the place.
if [[ "${WM}" =~ "awesome" ]]; then
    # Awesome: /etc/X11/Sessions/awesome -c ~/.config/awesome/rc.lua
    WM=( /etc/X11/Sessions/awesome -c ~/.config/awesome/rc.lua )
elif [[ "${WM}" =~ "compiz" ]];then
    WM=( "compiz.sh" )
elif [[ "${WM}" =~ "emacs" ]];then
    # Just "emacs" would suffice if you don't mind a M-x:exwm-init on X boot.
    # emacs --daemon -f exwm-enable
    emacs --daemon
    WM=( "emacsclient" "-c" )
elif [[ "${WM}" =~ "starte16" || "${WM}" =~ "enlightenment_start" ]];then
    # e17 svg support
    export E_COMP_ENGINE=sw
fi

exec "${WM[@]}"
