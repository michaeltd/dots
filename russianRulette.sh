#!/bin/env /bin/bash
# https://www.facebook.com/freecodecamp/photos/a.1535523900014339.1073741828.1378350049065059/2006986062868118/?type=3&theater
# [ $[ $RANDOM % 6 ] == 0 ] && echo "BOOM!!!" || echo "LUCKY GUY!!!"

let "RV = $RANDOM % 6";

if [[ $RV == 0 ]]; then
  echo "BOOM!!! You've rolled a ${RV}"
else
  echo "LUCKY GUY!!! You've rolled a ${RV}"
fi
