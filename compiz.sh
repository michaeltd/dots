#!/bin/env /bin/bash
# Start Compiz
/usr/bin/compiz-manager &

if [ -r "${HOME}"/bin/autostart.sh ]; then
    "${HOME}"/bin/autostart.sh
fi

# A nice status bar
tint2 &

# Wait
sleep 999d
