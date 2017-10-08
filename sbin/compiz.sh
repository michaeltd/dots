#!/bin/env /bin/bash
# Start Compiz
/usr/bin/compiz-manager &

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
