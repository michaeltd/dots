# ~/.bashrc.d/.stl/temp.bash
#
# Temperature conversions celsius - fahrenheit - kelvin
#shellcheck shell=bash

c2f() {
    echo "scale=2;((9/5) * ${1}) + 32"|bc -ql
}

c2k() {
    echo "scale=2;${1} + 273.15"|bc -ql
}

k2c() {
    echo "scale=2; ${1} - 273.15"|bc -ql
}

k2f() {
    echo "scale=2;((9/5) * $(k2c "${1}")) + 32"|bc -ql
}

f2c() {
    echo "scale=2;(${1} - 32) * (5 / 9)"|bc -ql
}

f2k() {
    echo "scale=2;$(f2c "${1}") + 273.15"|bc -ql
}
