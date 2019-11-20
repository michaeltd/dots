#!/bin/sh
#
# https://www.reddit.com/r/unixporn/comments/amkpy4/2bwm_made_a_popup_calendar/
# https://github.com/sawsuh/dotfiles2018/blob/master/scripts/cal.sh

# # k=$(xdotool search --classname cal)
# k=$(xdotool search --name cal)
# hex=$(printf '%x\n' $k)
# if [ $hex == "0" ]; then
xterm -g 20x9 -title cal -hold -e cal -m &
# else
#     xkill -id $k;
# fi
