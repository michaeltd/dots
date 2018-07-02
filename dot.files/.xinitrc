# ~/.xinitrc
# This file is sourced when running startx and other programs which call xinit. As in all Bash/sh scripts lines starting with '#' are comments

# xsetbg -fullscreen ~/.wallpapers/emacs-cheat-sheet.png & # Set background to your favorite pic
# terminology & # Start a XTerm
xrdb -merge ~/.Xresources # >> /dev/null 2>&1 # X things
xset b off # Silence terminal bell
xset m 20/10 4 # Mouse acceleration

export E_COMP_ENGINE=sw # e17 svg support
source /etc/os-release # Pick a wm for your distro # enlightenment_start starte16 startxfce4 kodi-standalone compiz.sh mwm jwm wmaker
if [[ "${ID}" == "gentoo" ]]; then
  WM=$(which wmaker)
elif [[ "${ID}" == "devuan" ]]; then
  WM=$(which compiz.sh)
else
  WM=$(which wmaker)
fi

# exec /etc/alternatives/x-window-manager # Start the systems window manager. See WindowManagers for other choices.
# exec gnome-session # To run Gnome instead of system default, place a '#' before the previous line and uncomment the next line.
# exec /etc/X11/Sessions/awesome -c ~/.awesome/rc.lua # If awesome
exec dbus-launch --exit-with-session "${WM}"
