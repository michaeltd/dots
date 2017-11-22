#!/usr/bin/env /bin/bash
# Start Compiz
# /usr/bin/compiz-manager &
# compiz --replace &
# fusion-icon &
# emerald --replace &
# compiz --replace "$@" &

compiz &
ck-launch-session dbus-launch compiz ccsm

assh="${HOME}"/bin/autostart.sh
if [[ -x "${assh}" ]]; then
    "${assh}"
fi

# A nice status bar
#tint2 &
#dzen2 -dock &

# Networking
#wicd-gtk -t &

# Wait
sleep 999d
