#
# Distance conversions
#shellcheck shell=bash

ml2km() {
    #shellcheck disable=SC2005
    printf "%.2f\n" "$(echo "scale=2;${1} / 0.621371192237334"|bc -ql)"
}

km2ml() {
    #shellcheck disable=SC2005
    printf "%.2f\n" "$(echo "scale=2;${1} * 0.621371192237334"|bc -ql)"
}

mph2kph() {
    ml2km "${1}"
}

kph2mph() {
    km2ml "${1}"
}
