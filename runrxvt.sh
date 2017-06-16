
#set CMD=""

if (( $# >= 1 )) ; then
	CMD="-e ${1}"
fi

urxvt \
    -ls \
    -geometry 120x40 \
    -sl 99999 \
    -fn "9x15bold,xft:Bitstream Vera Sans Mono" \
    -bg Black \
    -fg Green3 \
    +sb \
    $CMD
