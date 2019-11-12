# ~/.bashrc.d/temp.sh
#
# Temperature conversions

ctof() {
  printf "%.2f\n" $(echo "scale=2;((9/5) * ${1}) + 32"|bc)
}

ctok() {
  printf "%.2f\n" $(echo "scale=2;${1} + 273.15"|bc)
}

ktoc() {
  printf "%.2f\n" $(echo "scale=2; ${1} - 273.15"|bc)
}

ktof() {
  printf "%.2f\n" $(echo "scale=2;((9/5) * $(ktoc ${1})) + 32"|bc)
}

ftoc() {
  printf "%.2f\n" $(echo "scale=2;(${1} - 32) * (5 / 9)"|bc)
}

ftok() {
  printf "%.2f\n" $(echo "scale=2;$(ftoc ${1}) + 273.15"|bc)
}
