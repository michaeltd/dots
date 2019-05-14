# ~/.xinitrc
#
# Or: "The dedicated WM hoppers ~/.xinitrc"

# ~/.Xresources
[[ -f ~/.Xresources ]] && xrdb -I"${HOME}" -merge ~/.Xresources

# Silence terminal bell
xset b off

# Mouse acceleration
xset m 20/10 4

# Qt5 theme engine
export QT_QPA_PLATFORMTHEME=qt5ct

declare -A WMA=( [openbox]="openbox-session" [wmaker]="wmaker" [jwm]="jwm" [awesome]="awesome" [mwm]="mwm" [fvwm-crystal]="fvwm-crystal" [fvwm]="fvwm" [e16]="starte16" [enlightenment]="enlightenment_start" [xfce4]="xfce4-session" [compiz]="compiz.sh" [emacs]="emacs" [kodi]="kodi-standalone" )

# Per distro selection. If you've got preferences for specific distros, set them up here.
source /etc/os-release
if [[ "${ID}" == "gentoo" ]]; then
    WM="${WMA[awesome]}"
elif [[ "${ID}" == "devuan" ]]; then
    WM="${WMA[xfce4]}"
else
    # Availability check, One line version: WM=$(which openbox-session||which wmaker||which jwm||which awesome||which mwm||which fvwm-crystal||which fvwm||which starte16||which enlightenment_start||which xfce4-session||which compiz||which emacs||which kodi-standalone)
    for x in "${!WMA[@]}"; do
        if [[ -x "$(which ${WMA[$x]} 2> /dev/null)" ]]; then
            WM="${WMA[$x]}"
            break
        fi
    done
fi

# Arguments check. If startx has an argument (eg: xfce4), set it up.
for y in ${@}; do
    for z in "${!WMA[@]}"; do
        if [[ "${y}" =~ "${z}" ]]; then
            WM="${WMA[$z]}"
            break
        fi
    done
done

# Per wm customizations. If there is a wm specific permutation to be done, here is the place.
if [[ "${WM}" =~ "awesome" ]]; then
    # Awesome: /etc/X11/Sessions/awesome -c ~/.config/awesome/rc.lua
    WM=( /etc/X11/Sessions/awesome --replace --config ~/.config/awesome/rc.lua )
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
