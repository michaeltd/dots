# ~/.xinitrc
#!/usr/bin/env bash
#
# This file is sourced when running startx and other programs which call xinit. As in all Bash/sh scripts lines starting with '#' are comments
# xsetbg -fullscreen ~/.wallpapers/emacs-cheat-sheet.png & # Set background to your favorite pic
# terminology & # Start a XTerm

# ~/.Xresources
xrdb -I"${HOME}" -merge ~/.Xresources

# Silence terminal bell
xset b off

# Mouse acceleration
xset m 20/10 4

# Pick a wm:
wms=( openbox-session wmaker awesome mwm jwm starte16 enlightenment_start xfce4-session compiz kodi-standalone emacs )
source /etc/os-release
if [[ "${ID}" == "devuan" ]]; then
  WM="xfce4-session"
elif [[ "${ID}" == "gentoo" ]]; then
  WM="openbox-session"
else
  # there is a one-liner for this but i like the verbosity of a 'for' statement.
  # WM=$(which wmaker||which openbox-session||which jwm||which mwm||which compiz.sh||which starte16||which enlightenment_start||which xfce4-session||which kodi-standalone)
  for wm in "${wms[@]}"; do
    if [[ -x "$(which ${wm} 2> /dev/null)" ]]; then
      WM="${wm}"
      break
    fi
  done
fi

# Start the systems window manager. See WindowManagers for other choices.
# exec /etc/alternatives/x-window-manager
# To run Gnome instead of system default, place a '#' before the previous line and uncomment the next line.
# exec gnome-session
# exec dbus-launch --exit-with-session "${WM}"

# Customizations per wm. If there is a wm specific permutation to be done, set it up here.
if [[ "${WM}" =~ "awesome" ]];then
  # Awesome: /etc/X11/Sessions/awesome -c ~/.config/awesome/rc.lua
  WM=( /etc/X11/Sessions/awesome -c ~/.config/awesome/rc.lua )
elif [[ "${WM}" =~ "emacs" ]];then
  # Emacs (with (exwm-enable) commented out in "exwm-config") as found in exwm manual:
  # emacs --daemon -f exwm-enable
  # emacsclient -c
  # Just "emacs" would be sufficient if you dont mind X clients M-x:exwm-init on X boot.
  emacs --daemon -f exwm-enable
  WM=( emacsclient -c )
elif [[ "${WM}" =~ "e16" || "${WM}" =~ "enlightenment" ]];then
  # e17 svg support
  export E_COMP_ENGINE=sw
fi

exec "${WM[@]}"
