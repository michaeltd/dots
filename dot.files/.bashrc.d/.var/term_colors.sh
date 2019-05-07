# ~/.bashrc.d/term_colors.sh
#
# color gym for the terminal

function color_test {
  #   Daniel Crisman's ANSI color chart script from
  #   The Bash Prompt HOWTO: 6.1. Colours
  #   http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
  #
  #   This function echoes a bunch of color codes to the
  #   terminal to demonstrate what's available.  Each
  #   line is the color code of one forground color,
  #   out of 17 (default + 16 escapes), followed by a
  #   test use of that color on all nine background
  #   colors (default + 8 escapes).
  #

  T='gYw'   # The test text

  echo -e "\n         def     40m     41m     42m     43m     44m     45m     46m     47m";

  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
                     '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
                     '  36m' '1;36m' '  37m' '1;37m';

  do FG=${FGs// /}
     echo -en " $FGs \033[$FG  $T  "

     for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
     do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
     done
     echo;
  done
  echo
}

function fancy_pacman {
  # from: http://dotshare.it/dots/562/

  f=3 b=4
  for j in f b; do
    for i in {0..7}; do
      printf -v $j$i %b "\e[${!j}${i}m"
    done
  done
  bld=$'\e[1m'
  rst=$'\e[0m'
  inv=$'\e[7m'

  cat << EOF

$rst
$f3  ▄███████▄                $f1  ▄██████▄    $f2  ▄██████▄    $f4  ▄██████▄    $f5  ▄██████▄    $f6  ▄██████▄
$f3▄█████████▀▀               $f1▄$f7█▀█$f1██$f7█▀█$f1██▄  $f2▄█$f7███$f2██$f7███$f2█▄  $f4▄█$f7███$f4██$f7███$f4█▄  $f5▄█$f7███$f5██$f7███$f5█▄  $f6▄██$f7█▀█$f6██$f7█▀█$f6▄
$f3███████▀      $f7▄▄  ▄▄  ▄▄   $f1█$f7▄▄█$f1██$f7▄▄█$f1███  $f2██$f7█ █$f2██$f7█ █$f2██  $f4██$f7█ █$f4██$f7█ █$f4██  $f5██$f7█ █$f5██$f7█ █$f5██  $f6███$f7█▄▄$f6██$f7█▄▄$f6█
$f3███████▄      $f7▀▀  ▀▀  ▀▀   $f1████████████  $f2████████████  $f4████████████  $f5████████████  $f6████████████
$f3▀█████████▄▄               $f1██▀██▀▀██▀██  $f2██▀██▀▀██▀██  $f4██▀██▀▀██▀██  $f5██▀██▀▀██▀██  $f6██▀██▀▀██▀██
$f3  ▀███████▀                $f1▀   ▀  ▀   ▀  $f2▀   ▀  ▀   ▀  $f4▀   ▀  ▀   ▀  $f5▀   ▀  ▀   ▀  $f6▀   ▀  ▀   ▀
$bld
$f3  ▄███████▄                $f1  ▄██████▄    $f2  ▄██████▄    $f4  ▄██████▄    $f5  ▄██████▄    $f6  ▄██████▄
$f3▄█████████▀▀               $f1▄$f7█▀█$f1██$f7█▀█$f1██▄  $f2▄█$f7█ █$f2██$f7█ █$f2█▄  $f4▄█$f7█ █$f4██$f7█ █$f4█▄  $f5▄█$f7█ █$f5██$f7█ █$f5█▄  $f6▄██$f7█▀█$f6██$f7█▀█$f6▄
$f3███████▀      $f7▄▄  ▄▄  ▄▄   $f1█$f7▄▄█$f1██$f7▄▄█$f1███  $f2██$f7███$f2██$f7███$f2██  $f4██$f7███$f4██$f7███$f4██  $f5██$f7███$f5██$f7███$f5██  $f6███$f7█▄▄$f6██$f7█▄▄$f6█
$f3███████▄      $f7▀▀  ▀▀  ▀▀   $f1████████████  $f2████████████  $f4████████████  $f5████████████  $f6████████████
$f3▀█████████▄▄               $f1██▀██▀▀██▀██  $f2██▀██▀▀██▀██  $f4██▀██▀▀██▀██  $f5██▀██▀▀██▀██  $f6██▀██▀▀██▀██
$f3  ▀███████▀                $f1▀   ▀  ▀   ▀  $f2▀   ▀  ▀   ▀  $f4▀   ▀  ▀   ▀  $f5▀   ▀  ▀   ▀  $f6▀   ▀  ▀   ▀
$rst
EOF
}
