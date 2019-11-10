#!/bin/bash

# File Name: show256color.sh
# Author: philosophos<philosoph@yeah.net>
# GitHub: https://github.com/philosophos/show256color
# Create Time: 2017 Feb 08
# Last modified: 2017 Feb 20
# show 256color in terminal
################################################################################

setColor()
{
    #[[ $BF == "b" ]] && tput setab $i && tput setaf 0
    #[[ $BF == "f" ]] && tput setaf $i && tput setab 0
    if [ $BF == "b" ];then tput setab $i
        [[ $i -eq 0 || $i -eq 16 || $i -ge 232 && $i -le 243 ]]\
            && tput setaf 15 || tput setaf 0
    fi
    if [ $BF == "f" ];then tput setaf $i
        [[ $i -eq 0 || $i -eq 16 || $i -ge 232 && $i -le 243 ]]\
            && tput setab 15 || tput setab 0
    fi
}

showColor()
{
    setColor $BF $i
    if [ $HEX == 0 ]&&[ $RGB == 0 ];then
        printf ' %3d ' $i
    elif [ $HEX == 0 ]&&[ $RGB == 1 ];then
        printf '      %3d     ' $i
    elif [ $HEX == 1 ]&&[ $RGB == 0 ];then
        printf ' %3d #%02x%02x%02x ' $i $R $G $B
    else
        printf '  %3d #%02x%02x%02x ' $i $R $G $B
    fi
    if [ $RGB == 1 ];then
            printf "\e[0m\v\e[14D"
            setColor $BF $i
            printf " R%03dG%03dB%03d \e[A" $R $G $B
    fi
    tput sgr0
}

256color()
{
    #color 0~15
    #array_r=(00 80 00 80 00 80 00 c0 80 ff 00 ff 00 ff 00 ff)
    #array_g=(00 00 80 80 00 00 80 c0 80 00 ff ff 00 00 ff ff)
    #array_b=(00 00 00 00 80 80 80 c0 80 00 00 00 ff ff ff ff)
    array_r=(000 128 000 128 000 128 000 192 128 255 000 255 000 255 000 255)
    array_g=(000 000 128 128 000 000 128 192 128 000 255 255 000 000 255 255)
    array_b=(000 000 000 000 128 128 128 192 128 000 000 000 255 255 255 255)
    for i in {0..15};do
        R=${array_r[i]}
        G=${array_g[i]}
        B=${array_b[i]}
        showColor $BF $i $HEX $RGB
        if [ $(((i+1)%8)) -eq 0 ];then
            [[ $RGB -eq 0 ]]&& echo '' || echo -e '\n'
        fi
    done
    #color 16~231
    R=0;G=0;B=0;step=51
    for blk in {0..2};do
        for ((line=blk*12;line<blk*12+6;line++));do
            for ((i=line*6+16;i<line*6+22;i++));do
                showColor $BF $i $HEX $RGB;B=$((B+step))
            done
            B=0; R=$((R+step))
            for ((i=line*6+52;i<line*6+58;i++));do
                showColor $BF $i $HEX $RGB;B=$((B+step))
            done
            B=0; R=$((R-step));G=$((G+step))
            [[ $RGB -eq 0 ]]&& echo '' || echo -e '\n'
        done
        G=0; R=$((R+step*2))
    done
    #color 232~255
    R=8;G=8;B=8;step=10
    for i in {232..255};do
        showColor $BF $i $HEX $RGB
        if [ $(((i-15)%12)) -eq 0 ];then
            [[ $RGB -eq 0 ]]&& echo '' || echo -e '\n'
        fi
        R=$((R+step));G=$((G+step));B=$((B+step))
    done
}

HELP="
The script show 256color in terminal\n
Helpful for configuring terminal program colorscheme, like vim,tmux,bash,zsh,etc.\n
Note that if color 0~15 was changed in terminal by configuration file or\n
CLI option, the corresponding hex & RGB value will be shown falsely.\n
Author: philosophos<philosoph@yeah.net> \n
GitHub: https://github.com/philosophos/show256color \n
Usage:\n
\t./show256color [option]\n
without option,show 256color in background.\n
options:\n
\t[b|-b|bg|-bg|--background]\tshow 256color in background(default)\n
\t[f|-f|fg|-fg|--foregroung]\tshow 256color in foreground\n
\t[x|-x|hex|--hex]\t\talso show color value in hexadecimal\n
\t[r|-r|rgb|--rgb]\t\talso show color value in RGB\n
\t[h|-h|help|--help]\t\tshow the help\n
"

[[ $(tput colors)==256 ]]||\
    echo -e "\e[33m The terminal does NOT support 256color :("
BF='b';HEX=0;RGB=0
if [ $# -gt 0 ];then
    ARGS=`getopt -o "bfxrh" -l "background,foreground,bg,fg,hex,rgb,help"\
    -n "show256color.sh" -- "$@"`
    eval set -- "${ARGS}"
    for opt in "$@"; do
        case $opt in
            b|-b|bg|--bg|--background)BF='b';shift;;
            f|-f|fg|--fg|--foreground)BF='f';shift;;
            x|-x|hex|--hex)HEX=1;shift;;
            r|-r|rgb|--rgb)RGB=1;shift;;
            h|-h|help|--help)echo -e $HELP;shift;exit;;
            --)shift;;
            *)echo -e "\e[33m Parameter ERROR!\e[0m For more details see
                help.";exit 1;;
        esac
    done
fi

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then

  256color $BF $HEX $RGB
fi


###############################################################################
#0~7 8~15
#from vim help cterm-colors
#    NR-16   NR-8    COLOR NAME ~
#    0      0     Black
#    1      4     DarkBlue
#    2      2     DarkGreen
#    3      6     DarkCyan
#    4      1     DarkRed
#    5      5     DarkMagenta
#    6      3     Brown, DarkYellow
#    7      7     LightGray, LightGrey, Gray, Grey
#    8      0*      DarkGray, DarkGrey
#    9      4*      Blue, LightBlue
#    10     2*      Green, LightGreen
#    11     6*      Cyan, LightCyan
#    12     1*      Red, LightRed
#    13     5*      Magenta, LightMagenta
#    14     3*      Yellow, LightYellow
#    15     7*      White
#16~231
#    216 colors
#    r,g,b=0~5
#    $d=15+r*36+g*6+b
#232~255
#    24 grey levels,from black to white
#
