#!/bin/bash

while read i ; do
    if [[ -n "$(qdepends -Qq $i)" ]]; then
        echo '' ; echo 'checking '$i
        if [[ -n "$(emerge -p --quiet --depclean $i)" ]]; then
            echo $i' needs to stay in @world'
        else
            echo $i' can be deselected'
            echo $i >> /tmp/deselect
        fi
    fi
done < /var/lib/portage/world
