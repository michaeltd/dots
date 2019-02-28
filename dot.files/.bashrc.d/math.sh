# ~/.bashrc.d/math.sh
#
# math related functions

#• calc()
function calc {
  # TODO
  # let, expr, dc, bc

  # let "a = ${@}"
  # echo $a

  # expr "${@}"

  # dc -e "${@}"

  # echo -e "Usage: calc \"1+2-3%2/1*10+(4*5)-(8*8)\"\n"
  echo "scale=6;${@}"| bc -l
}

#• min()
function min {
  printf "%d\n" "${@}" | sort -n | head -1
}

#• max()
function max {
  printf "%d\n" "${@}" | sort -rn | head -1
}

#• sqrt()
function sqrt {
  echo "scale=6;sqrt(${1})"| bc -l
}

function sqr {
  echo "scale=6;${1}^2"| bc -l
}

#• pow()
function powr {
  echo "scale=6;${1}^${2}"| bc -l
}

#• clamp()
#• atan2()
#• hypot()

# Trigonometric functions
# https://advantage-bash.blogspot.com/2012/12/trignometry-calculator.html
# • sin()
function sin {
  echo "scale=5;s($1)" | bc -l
}

#• cos()
function cos {
  echo "scale=5;c($1)" | bc -l
}

#• tan()
function tan {
  echo "scale=5;s($1)/c($1)" | bc -l
}

function csc {
  echo "scale=5;1/s($1)" | bc -l
}

function sec {
  echo "scale=5;1/c($1)" | bc -l
}

function ctn {
  echo "scale=5;c($1)/s($1)" | bc -l
}

#• asin()
function asin {
  if (( $(echo "$1 == 1" | bc -l) ));then
    echo "90"
  elif (( $(echo "$1 < 1" | bc -l) ));then
    echo "scale=3;a(sqrt((1/(1-($1^2)))-1))" | bc -l
  elif (( $(echo "$1 > 1" | bc -l) ));then
    echo "error"
  fi
}

#• acos()
function acos {
  if (( $(echo "$1 == 0" | bc -l) ));then
    echo "90"
  elif (( $(echo "$1 <= 1" | bc -l) ));then
    echo "scale=3;a(sqrt((1/($1^2))-1))" | bc -l
  elif (( $(echo "$1 > 1" | bc -l) ));then
    echo "error"
  fi
}

#• atan()
function atan {
  echo "scale=5;a($1)" | bc -l
}

function acot {
  echo "scale=5;a(1/$1)" | bc -l
}

function asec {
  echo "scale=5;a(sqrt(($1^2)-1))" | bc -l
}

function acsc {
  echo "scale=5;a(1/(sqrt($1^2)-1))" | bc -l
}
