# ~/.bashrc.d/.stdlib/temp.bash
#
# Temperature conversions celsius - fahrenheit - kelvin
#shellcheck shell=bash

c2f() {
    printf "%.2f\n" "$(echo "scale=2;(${1} * 1.8) + 32"|bc -ql)"
}

c2k() {
    printf "%.2f\n" "$(echo "scale=2;${1} + 273.15"|bc -ql)"
}

f2c() {
    printf "%.2f\n" "$(echo "scale=2;(${1} - 32) / 1.8"|bc -ql)"
}

f2k() {
    printf "%.2f\n" "$(echo "scale=2;$(f2c "${1}") + 273.15"|bc -ql)"
}

k2c() {
    printf "%.2f\n" "$(echo "scale=2;${1} - 273.15"|bc -ql)"
}

k2f() {
    printf "%.2f\n" "$(echo "scale=2;((9/5) * $(k2c "${1}")) + 32"|bc -ql)"
}
