#!/bin/env /bin/bash
# Start Compiz
/usr/bin/compiz-manager &

if [ -r "${HOME}"/bin/autostart.sh ]; then
    "${HOME}"/bin/autostart.sh
fi

# A nice status bar
tint2 &
#dzen2 -dock &

# Networking
wicd-gtk -t &

# Wait
sleep 999d
