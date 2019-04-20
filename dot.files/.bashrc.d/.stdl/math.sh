# ~/.bashrc.d/math.sh
#
# math related functions

calc() {
  # echo -e "Usage: calc \"1+2-3%2/1*10+(4*5)-(8*8)\"\n"
  echo "scale=6;${@}"| bc -l
}

min() {
  printf "%s\n" "${@}" | sort -n | head -1
}

altmin(){
    local n=${1} # Avoid n initialization issues
    while [[ -n ${1} ]]; do
        local n=$(( n < $1 ? n : $1 ))
        shift
    done
    echo ${n}
}

max() {
  printf "%s\n" "${@}" | sort -rn | head -1
}


altmax(){
    local x=${1} # Avoid x initialization issues
    while [[ -n ${1} ]]; do
        local x=$(( x > $1 ? x : $1 ))
        shift
    done
    echo ${x}
}

function sqrt {
  echo "scale=6;sqrt(${1})"| bc -l
}

function sqr {
  echo "scale=6;${1}^2"| bc -l
}

function powr {
  echo "scale=6;${1}^${2}"| bc -l
}

#• clamp()
#• atan2()
#• hypot()

# Trigonometric functions
# https://advantage-bash.blogspot.com/2012/12/trignometry-calculator.html
function sin {
  echo "scale=6;s($1)" | bc -l
}

function cos {
  echo "scale=6;c($1)" | bc -l
}

function tan {
  echo "scale=6;s($1)/c($1)" | bc -l
}

function csc {
  echo "scale=6;1/s($1)" | bc -l
}

function sec {
  echo "scale=6;1/c($1)" | bc -l
}

function ctn {
  echo "scale=6;c($1)/s($1)" | bc -l
}

function asin {
  if (( $(echo "$1 == 1" | bc -l) ));then
    echo "90"
  elif (( $(echo "$1 < 1" | bc -l) ));then
    echo "scale=6;a(sqrt((1/(1-($1^2)))-1))" | bc -l
  elif (( $(echo "$1 > 1" | bc -l) ));then
    echo "error"
  fi
}

function acos {
  if (( $(echo "$1 == 0" | bc -l) ));then
    echo "90"
  elif (( $(echo "$1 <= 1" | bc -l) ));then
    echo "scale=6;a(sqrt((1/($1^2))-1))" | bc -l
  elif (( $(echo "$1 > 1" | bc -l) ));then
    echo "error"
  fi
}

function atan {
  echo "scale=6;a($1)" | bc -l
}

function acot {
  echo "scale=6;a(1/$1)" | bc -l
}

function asec {
  echo "scale=6;a(sqrt(($1^2)-1))" | bc -l
}

function acsc {
  echo "scale=6;a(1/(sqrt($1^2)-1))" | bc -l
}
