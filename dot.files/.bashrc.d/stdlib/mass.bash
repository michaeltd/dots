#
# Mass conversions kg/lb
#shellcheck shell=bash

kg2lb() {
    printf "%.2f\n" "$(echo "scale=2;${1} * 2.20462262185"|bc -ql)"
}

lb2kg() {
    printf "%.2f\n" "$(echo "scale=2;${1} / 2.20462262185"|bc -ql)"
}
