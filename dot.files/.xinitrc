# ~/.xinitrc
# Or: "The dedicated WM hoppers .xinitrc"

# ~/.Xresources
xrdb -I"${HOME}" -merge ~/.Xresources

# Silence terminal bell
xset b off

# Mouse acceleration
xset m 20/10 4

# Pick a wm:
# -   -0--------------- -1------ -2--- -3------- -4--- -5-------- -6------------------- -7------------- -8------ -9----- -10--------------
wms=( "openbox-session" "wmaker" "jwm" "awesome" "mwm" "starte16" "enlightenment_start" "xfce4-session" "compiz" "emacs" "kodi-standalone" )

# Per distro selection. If you've got preferences for specific distros, set them up here.
source /etc/os-release
if [[ "${ID}" == "devuan" ]]; then
  WM="${wms[7]}"
elif [[ "${ID}" == "gentoo" ]]; then
  # WM="${wms[0]}"
  WM="${wms[8]}"
else
  # Availability check
  #
  # One line version.
  # WM=$(which openbox-session||which wmaker||which jwm||which awesome||which mwm||which starte16||which enlightenment_start||which xfce4-session||which compiz||which emacs||which kodi-standalone)
  for wm in "${wms[@]}"; do
    if [[ -x "$(which ${wm} 2> /dev/null)" ]]; then
      WM="${wm}"
      break
    fi
  done

  # Arguments check. If startx has an argument (eg: xfce4), set it up here
  for a in "${@}"; do
    for (( x=0; x<"${#wms[@]}"; x++ )); do
      if [[ "${a}" =~ "${wms[$x]}" ]]; then
        WM="${wms[$x]}"
      fi
    done
  done
fi

# Per wm customizations. If there is a wm specific permutation to be done, set it up here.
if [[ "${WM}" =~ "${wms[3]}" ]]; then
  # Awesome: /etc/X11/Sessions/awesome -c ~/.config/awesome/rc.lua
  WM=( /etc/X11/Sessions/awesome -c ~/.config/awesome/rc.lua )
elif [[ "${WM}" =~ "${wms[8]}" ]];then
  WM=( "compiz.sh" )
elif [[ "${WM}" =~ "${wms[9]}" ]];then
  # Just "emacs" could suffice if you don't mind a M-x:exwm-init on X boot.
  # emacs --daemon -f exwm-enable
  emacs --daemon # -f exwm-enable
  WM=( "emacsclient" "-c" )
elif [[ "${WM}" =~ "${wms[5]}" || "${WM}" =~ "${wms[6]}" ]];then
  # e17 svg support
  export E_COMP_ENGINE=sw
fi

exec "${WM[@]}"
