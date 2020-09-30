#
# Distance conversions
#shellcheck shell=bash disable=SC2005

ml2km() {
    printf "%.2f\n" "$(echo "scale=2;${1} / 0.621371192237334"|bc -ql)"
}

km2ml() {
    printf "%.2f\n" "$(echo "scale=2;${1} * 0.621371192237334"|bc -ql)"
}

mph2kph() {
    ml2km "${1}"
}

kph2mph() {
    km2ml "${1}"
}

in2cm() {
    printf "%.2f\n" "$(echo "scale=2;${1} * 2.54"|bc -ql)"
}

cm2in() {
    printf "%.2f\n" "$(echo "scale=2;${1} / 2.54"|bc -ql)"
}
