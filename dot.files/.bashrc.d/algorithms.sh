# ~/.bashrc.d/algorithms.sh
#
# algorithms in bash

# ALGO ========================================================================

function factorial {
  # https://rosettacode.org/wiki/Factorial
  if [ $1 -le 1 ]
  then
    echo 1
  else
    result=$(factorial $[$1-1])
    echo $((result*$1))
  fi
}

function bessel { # [order] [limit] Crude bessel graph https://www.reddit.com/r/bash/comments/ax0ah0/crude_bessel_graph/
  # example: for n in {0..19}; do bessel $n $((LINES/2)); sleep 1; done
  int=${1:-9}; limit=${2:-200}
  for ((i=-$limit; i<=$limit; i++)); do
    pad=$(bc -l <<< "j($int,$i)*($COLUMNS/2)+($COLUMNS/2)+.5")
    printf '% *d\n' ${pad%.*} $i

    sleep .03
  done
}
