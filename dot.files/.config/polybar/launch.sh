#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 2; done

# Launch bar1 and bar2
#polybar bar1 &
#polybar bar2 &
polybar topbar &

#polybar -c ~/git/dots/.local/etc/themer/themes/daftpunk-black/polybar top >> /dev/null 2>&1 &
#polybar -c ~/git/dots/.local/etc/themer/themes/daftpunk-black/polybar bottom >> /dev/null 2>&1 &

#polybar -c ~/git/dots/.local/etc/themer/themes/c64/polybar top >> /dev/null 2>&1 &
#polybar -c ~/git/dots/.local/etc/themer/themes/c64/polybar bottom >> /dev/null 2>&1 &

#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/bw/polybar bottom >> /dev/null 2>&1 &

#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/dracula/polybar top >> /dev/null 2>&1 &

#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/darkpx/polybar top &
#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/darkpx/polybar bottom &

#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/ethernet/polybar top &
#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/ethernet/polybar bottom &

#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/heroku/polybar top &
#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/heroku/polybar external_bottom &

#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/heroku/polybar top &
#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/heroku/polybar external_bottom &

#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/lightpx/polybar top &
#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/lightpx/polybar bottom &

#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/space/polybar top &
#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/space/polybar bottom &

#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/vibrant/polybar top &
#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/vibrant/polybar external_bottom &

#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/wasp/polybar top &
#polybar -c /home/paperjam/git/dots/.local/etc/themer/themes/wasp/polybar external_bottom &

echo "Bars launched..."
