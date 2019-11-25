# ~/.bashrc.d/speed.sh
#
# Speed conversions
#shellcheck shell=bash

kmphtomph() {
  printf "%.2f\n" "$(echo "scale=2;${1} * 0.6213712"|bc)"
}

mphtokmph() {
  printf "%.2f\n" "$(echo "scale=2;${1} * 1.609344"|bc)"
}
