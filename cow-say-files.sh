#!/usr/bin/env /bin/bash

fls=( $(cowsay -l) )

for fl in ${fls[*]}; do

    xterm -ls -hold -e "lol.sh ${fl}" &
    
done
