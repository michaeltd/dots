#!/usr/bin/env /bin/bash

fls=( $(cowsay -l) )

for fl in ${fls[@]}; do

  echo "cow $fl says:"
  fortune |cowsay -f "${fl}" |lolcat
  #xterm -ls -hold -e "lol.sh ${fl}" &

done
