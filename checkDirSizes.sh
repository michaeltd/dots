#!/usr/bin/env /bin/bash

for d in $(ls --directory "${1-${HOME}}"/*); do
	du -hs "${d}"
done
