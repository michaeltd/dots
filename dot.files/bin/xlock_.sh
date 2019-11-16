#!/bin/bash

IMAGE=/tmp/i3lock.png
SCREENSHOT="scrot $IMAGE"

BLURTYPE="0x05"

$SCREENSHOT
convert $IMAGE -blur $BLURTYPE $IMAGE
i3lock -i $IMAGE
# i3lock --blur=10 --clock --indicator --insidecolor=232C31FF --ringcolor=9EA7A6FF --line-uses-inside --keyhlcolor=2A5491FF --bshlcolor=A03B1EFF --insidevercolor=232C31FF --insidewrongcolor=A03B1Eff --ringvercolor=9EA7A6FF --ringwrongcolor=3F4944FF --separatorcolor=2A5491FF --verifcolor=FFFFFFFF --wrongcolor=232C31FF --timecolor=9EA7A6FF --datecolor=9EA7A6FF
rm $IMAGE

exit 0
