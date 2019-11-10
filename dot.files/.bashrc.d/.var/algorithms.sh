# ~/.bashrc.d/algorithms.sh
#
# algorithms in bash

factorial() {
  # https://rosettacode.org/wiki/Factorial
  if [ $1 -le 1 ]
  then
    echo 1
  else
    result=$(factorial $[$1-1])
    echo $((result*$1))
  fi
}

bessel() {
  # https://www.reddit.com/r/bash/comments/ax0ah0/crude_bessel_graph/
  # [order] [limit] Crude bessel graph
  # example: for n in {0..19}; do bessel $n $((LINES/2)); sleep 1; done

  local int=${1:-9} limit=${2:-200}

  for ((i=-$limit; i <= $limit; i++))
  do
    pad=$(bc -l <<< "j($int,$i)*($COLUMNS/2)+($COLUMNS/2)+.5")
    printf '% *d\n' ${pad%.*} $i
    sleep .03
  done
}

UUID() {
  # https://en.wikipedia.org/wiki/Universally_unique_identifier
  # https://github.com/niieani/bash-oo-framework/blob/master/lib/String/UUID.sh

  local N B C='89ab'

  for (( N=0; N < 16; ++N ))
  do
    B=$(( $RANDOM%256 ))
    case $N in
      6) printf '4%x' $(( B%16 ));;
      8) printf '%c%x' ${C:$RANDOM%${#C}:1} $(( B%16 ));;
      3|5|7|9) printf '%02x-' $B;;
      *) printf '%02x' $B;;
    esac
  done
  echo
}
