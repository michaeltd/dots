# ~/.bashrc.d/temp.sh
#
# Temperature conversions

function ctof {
    printf "%.2f\n" $(echo "scale=2;((9/5) * ${1}) + 32"|bc)
}

function ctok {
    printf "%.2f\n" $(echo "scale=2;${1} + 273.15"|bc)
}

function ktoc {
    printf "%.2f\n" $(echo "scale=2; ${1} - 273.15"|bc)
}

function ktof {
    printf "%.2f\n" $(echo "scale=2;((9/5) * $(ktoc ${1})) + 32"|bc)
}

function ftoc {
    printf "%.2f\n" $(echo "scale=2;(${1} - 32) * (5 / 9)"|bc)
}

function ftok {
    printf "%.2f\n" $(echo "scale=2;$(ftoc ${1}) + 273.15"|bc)
}
