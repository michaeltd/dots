#!/bin/env /bin/bash
# Start Compiz
/usr/bin/compiz-manager &

if [ -r ~/bin/start-up.sh ]; then
    ~/bin/start-up.sh
fi

# Start Root Menu
#if [ -r ~/bin/appMenu.sh ]; then
#    ~/bin/appMenu.sh
#fi

# Wait
sleep 999d
