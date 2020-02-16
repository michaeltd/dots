# ~/.bashrc.d/.stl/distance.bash
#
# Distance conversions
#shellcheck shell=bash

mltokm() {
    #shellcheck disable=SC2005
    printf "%.2f\n" "$(echo "scale=2;${1} * 1.609344"|bc -ql)"
}

kmtoml(){
    #shellcheck disable=SC2005
    printf "%.2f\n" "$(echo "scale=2;${1} * 0.621371192237334"|bc -ql)"
}

mphtokph() {
    mltokm "${1}"
}

kphtomph() {
    kmtoml "${1}"
}
