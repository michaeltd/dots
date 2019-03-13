# ~/.bashrc.d/chubin.sh
#
# igor chubin

function cheatsh {
  # https://github.com/chubin/cheat.sh
  curl https://cheat.sh/${1}
}

function ccxrates {
  # https://twitter.com/igor_chubin
  curl https://${1:-"eur"}.rate.sx
}

function wttrin {
  # https://twitter.com/igor_chubin # Try wttr moon
  curl https://wttr.in/${1:-"Athens"}
}
