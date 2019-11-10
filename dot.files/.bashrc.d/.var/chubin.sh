# ~/.bashrc.d/chubin.sh
#
# igor chubin

cheatsh() {
  # https://github.com/chubin/cheat.sh
  curl https://cheat.sh/${1}
}

ccxrates() {
  # https://twitter.com/igor_chubin
  curl https://${1:-"eur"}.rate.sx
}

wttrin() {
  # https://twitter.com/igor_chubin # Try wttr moon
  curl https://wttr.in/${1:-"Athens"}
}
