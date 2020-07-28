#!/usr/bin/env bash

command -v emerge &>/dev/null || { echo -ne "Need a portage based distro!\n" >&2; exit 1; }

while read -r i ; do
    if [[ -n "$(qdepends -Qq "${i}")" ]]; then
	echo -ne "\nchecking ${i}\n"
	if [[ -n "$(emerge --pretend --quiet --depclean "${i}")" ]]; then
	    echo "${i} needs to stay in @world"
	else
	    echo "${i} can be deselected"
	    echo "${i}" >> /tmp/deselect
	fi
    fi
done < /var/lib/portage/world

echo "Packages in /tmp/deselect:"
cat /tmp/deselect
