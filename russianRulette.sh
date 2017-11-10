#!/bin/env /bin/bash
# https://www.facebook.com/freecodecamp/photos/a.1535523900014339.1073741828.1378350049065059/2006986062868118/?type=3&theater
# [ $[ $RANDOM % 6 ] == 0 ] && printf "BOOM\n" || printf "LUCKY GUY\n"

# V1.0
function rrv1() {
  #let "RV = $RANDOM % 6"
  export RV=$(shuf -n 1 -i 1-6)

  if [[ "${RV}" -eq "0" ]]; then
    printf "BOOM!!! You've rolled a %d\n" "${RV}"
  else
    printf "LUCKY GUY!!! You've rolled a %d\n" "${RV}"
  fi
}

# V2.0
function rrv2 {
  # TODO
  export revolver
  export bullet
  export possition

  function reload {
    revolver=( 0 0 0 0 0 0 )
    chamber=$(shuf -n 1 -i 1-6)
    hammer=$(shuf -n 1 -i 1-6)

    revolver[${chamber}]=1

  }

  reload

  let "uiCham = ${chamber} + 1"
  let "uiHamm = ${hammer} + 1"


  printf "chamber no %d has %d bullet and hammer is at %d\n" ${uiCham} ${revolver[${chamber}]} ${uiHamm}
}

rrv1
