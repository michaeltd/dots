# ~/.bashrc.d/speed.sh
#
# Speed conversions
#shellcheck shell=bash

kphtomph() {
  printf "%.2f\n" "$(echo "scale=2;${1} * 0.6213712"|bc)"
}

mphtokph() {
  printf "%.2f\n" "$(echo "scale=2;${1} * 1.609344"|bc)"
}
