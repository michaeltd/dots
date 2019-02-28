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
