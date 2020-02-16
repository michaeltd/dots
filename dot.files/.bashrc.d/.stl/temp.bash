# ~/.bashrc.d/.stl/temp.bash
#
# Temperature conversions celsius - fahrenheit - kelvin
#shellcheck shell=bash

ctof() {
  echo "scale=2;((9/5) * ${1}) + 32"|bc -ql
}

ctok() {
  echo "scale=2;${1} + 273.15"|bc -ql
}

ktoc() {
  echo "scale=2; ${1} - 273.15"|bc -ql
}

ktof() {
  echo "scale=2;((9/5) * $(ktoc "${1}")) + 32"|bc -ql
}

ftoc() {
  echo "scale=2;(${1} - 32) * (5 / 9)"|bc -ql
}

ftok() {
  echo "scale=2;$(ftoc "${1}") + 273.15"|bc -ql
}
