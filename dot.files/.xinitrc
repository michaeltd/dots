# ~/.xinitrc
#!/usr/bin/env bash
#
# This file is sourced when running startx and other programs which call xinit. As in all Bash/sh scripts lines starting with '#' are comments
# xsetbg -fullscreen ~/.wallpapers/emacs-cheat-sheet.png & # Set background to your favorite pic
# terminology & # Start a XTerm

# X things

xrdb -I${HOME} -merge ~/.Xresources

# Silence terminal bell
xset b off

# Mouse acceleration
xset m 20/10 4

# e17 svg support
export E_COMP_ENGINE=sw

# Pick a wm:
source /etc/os-release
if [[ "${ID}" == "devuan" ]]; then
  WM=$(which xfce4-session)
elif [[ "${ID}" == "gentoo" ]]; then
  WM=$(which openbox-session)
else
  WM=$(which wmaker|| \
      which openbox-session|| \
      which jwm|| \
      which mwm|| \
      which compiz.sh|| \
      which emacs|| \
      which starte16|| \
      which enlightenment_start|| \
      which xfce4-session|| \
      which kodi-standalone)
fi

# Start the systems window manager. See WindowManagers for other choices.
# exec /etc/alternatives/x-window-manager
# To run Gnome instead of system default, place a '#' before the previous line and uncomment the next line.
# exec gnome-session
# Awesome
# exec /etc/X11/Sessions/awesome -c ~/.config/awesome/rc.lua
# exec dbus-launch --exit-with-session "${WM}"
"${WM}"
