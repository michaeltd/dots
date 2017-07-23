#!/bin/bash
# X things
xrdb -merge ~/.Xresources 2> /dev/null

# import functions
source /etc/bash/bashrc.d/wallpaper-rotate.sh
# Add some wallpaper variety for your desktop
rotateBg &

# Monitor your box
#conky -DDDD -b -c ~/.conky.conf/.conkyrc.right.full >> ~/.conky.err/`date +%y%m%d`.conky.err.log 2>&1
#if [ -r "${HOME}"/bin/keepConkyAlive.sh ]; then
#    "${HOME}"/bin/keepConkyAlive.sh &
#fi
if [ -r "${HOME}"/bin/conkyStart.sh ]; then
    "${HOME}"/bin/conkyStart.sh &
fi

# Start a Menu just in case
if [ -r /usr/local/bin/TkRootMenu.sh ]; then
    /usr/local/bin/TkRootMenu.sh &
fi

# quit screensaver if running
xscreensaver-command -exit
# Start screensaver in the background
xscreensaver -nosplash &
