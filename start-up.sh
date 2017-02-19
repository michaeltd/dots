#!/bin/bash

# X things
xrdb ~/.Xresources 2> /dev/null

# import functions
source /etc/bash/bashrc.d/wallpaper-rotate.sh

# Add some wallpaper variety for your desktop
rotateBg &

# Monitor your box
#conky -DDDD -b -c ~/.conky.conf/.conkyrc.right.full >> ~/.conky.err/`date +%y%m%d`.conky.err.log 2>&1
~/bin/keepConkyAlive.sh &

# XScreenSaver stuff

xscreensaver-command -exit # quit screensaver if running

xscreensaver -nosplash & # Start screensaver in the background
