# Usage : runterm.sh term commd
# OR runterm.sh comm
# OR runterm.sh

TRM="terminology"

if (( $# == 1 )) ; then
    CMD="-e "$1""
fi

$TRM -g 120x40 $CMD
