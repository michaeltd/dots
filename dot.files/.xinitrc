# ~/.xinitrc
#
# Or: "The dedicated WM hoppers .xinitrc"

# ~/.Xresources
xrdb -I"${HOME}" -merge ~/.Xresources

# Silence terminal bell
xset b off

# Mouse acceleration
xset m 20/10 4

# Qt5
export QT_QPA_PLATFORMTHEME=qt5ct

# wms: WindowManagerS
# -   -0--------------- -1------ -2--- -3------- -4--- -5------------ -6---- -7-------- -8------------------- -9------------- -10----- -11---- -12--------------
WMS=( "openbox-session" "wmaker" "jwm" "awesome" "mwm" "fvwm-crystal" "fvwm" "starte16" "enlightenment_start" "xfce4-session" "compiz" "emacs" "kodi-standalone" )

# Per distro selection. If you've got preferences for specific distros, set them up here.
source /etc/os-release
if [[ "${ID}" == "devuan" ]]; then
    WM="xfce4-session"
elif [[ "${ID}" == "gentoo" ]]; then
    WM="compiz"
else
    # Availability check
    #
    # One line version.
    # WM=$(which openbox-session||which wmaker||which jwm||which awesome||which mwm||which fvwm-crystal||which fvwm||which starte16||which enlightenment_start||which xfce4-session||which compiz||which emacs||which kodi-standalone)
    for WM in "${WMS[@]}"; do
        if [[ -x "$(which ${WM} 2> /dev/null)" ]]; then
            WM="${WM}"
            break
        fi
    done

    # Arguments check. If startx has an argument (eg: xfce4), set it up.
    for x in ${@}; do
        for y in ${WMS[@]}; do
            if [[ "${x}" =~ "${WMS[$y]}" ]]; then
                WM="${WMS[$y]}"
            fi
        done
    done
fi

# Per wm customizations. If there is a wm specific permutation to be done, here is the place.
if [[ "${WM}" =~ "awesome" ]]; then
    # Awesome: /etc/X11/Sessions/awesome -c ~/.config/awesome/rc.lua
    WM=( /etc/X11/Sessions/awesome -c ~/.config/awesome/rc.lua )
elif [[ "${WM}" =~ "compiz" ]];then
    WM=( "compiz.sh" )
elif [[ "${WM}" =~ "emacs" ]];then
    # Just "emacs" could suffice if you don't mind a M-x:exwm-init on X boot.
    # emacs --daemon -f exwm-enable
    emacs --daemon
    WM=( "emacsclient" "-c" )
elif [[ "${WM}" =~ "starte16" || "${WM}" =~ "enlightenment_start" ]];then
    # e17 svg support
    export E_COMP_ENGINE=sw
fi

exec "${WM[@]}"

