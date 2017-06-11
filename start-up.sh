#!/bin/bash
# X things
xrdb ~/.Xresources 2> /dev/null
# import functions
#source /etc/wallpaper_rotate.source.sh
source /etc/bash/bashrc.d/wallpaper-rotate.sh

# Add some wallpaper variety for your desktop
rotateBg &
# Monitor your box
#conky -DDDD -b -c ~/.conky.conf/.conkyrc.right.full >> ~/.conky.err/`date +%y%m%d`.conky.err.log 2>&1
~/bin/conkyStart.sh &

# Start a Menu just in case
/usr/local/bin/TkRootMenu.sh

# quit screensaver if running
xscreensaver-command -exit
# Start screensaver in the background
xscreensaver -nosplash &
