# ~/.bashrc.d/temp.sh
#
# Temperature conversions
#shellcheck shell=bash

ctof() {
  echo "scale=2;((9/5) * ${1}) + 32"|bc
}

ctok() {
  echo "scale=2;${1} + 273.15"|bc
}

ktoc() {
  echo "scale=2; ${1} - 273.15"|bc
}

ktof() {
  echo "scale=2;((9/5) * $(ktoc "${1}")) + 32"|bc
}

ftoc() {
  echo "scale=2;(${1} - 32) * (5 / 9)"|bc
}

ftok() {
  echo "scale=2;$(ftoc "${1}") + 273.15"|bc
}
