# ~/.bashrc.d/aliases.bash
#
# Perfect alias candidates are one liners or functions that take no arguments.
#shellcheck shell=bash

# Distro independent utils
# Package Search, Install, Remove
# Distro Update, Upgrade, Cleanup
if type -P apt-get &> /dev/null; then
    alias pkg_search='apt search' pkg_install='sudo apt-get install' \
	  pkg_remove='sudo apt-get remove --purge'
    alias dist_update='sudo apt-get update' dist_upgrade='sudo apt-get dist-upgrade' \
	  dist_cleanup='sudo apt-get autoremove'
elif type -P zypper &> /dev/null; then
    alias pkg_search='zypper search' pkg_install='sudo zypper install' \
	  pkg_remove='sudo zypper remove --clean-deps'
    alias dist_update='sudo zypper refresh' dist_upgrade='sudo zypper update' \
	  dist_cleanup='sudo zypper rm -u'
elif type -P yum &> /dev/null; then
    alias pkg_search='yum search' pkg_install='sudo yum install' \
	  pkg_remove='sudo yum remove'
    alias dist_update='sudo yum check-update' dist_upgrade='sudo yum update' \
	  dist_cleanup='sudo yum autoremove'
elif type -P pacman &> /dev/null; then
    alias pkg_search='pacman -Ss' pkg_install='sudo pacman -S' \
	  pkg_remove='sudo pacman -R'
    alias dist_update='sudo pacman -Sy' dist_upgrade='sudo pacman -Syu' \
	  dist_cleanup='sudo pacman -Rsn'
elif type -P emerge &> /dev/null; then
    alias pkg_search='emerge -s' pkg_install='sudo emerge -av' \
	  pkg_remove='sudo emerge -avC'
    alias dist_update='sudo emerge --sync' dist_upgrade='sudo emerge -avuND @world' \
	  dist_cleanup='sudo emerge --ask --depclean'
elif type -P pkg &> /dev/null; then
    alias pkg_search='pkg -o search' pkg_install='sudo pkg install' \
	  pkg_remove='sudo pkg remove'
    alias dist_update='sudo pkg update' dist_upgrade='sudo pkg upgrade' \
	  dist_cleanup='sudo pkg autoremove'
fi

if [[ -x "$(type -P dircolors)" ]]; then
    # Color support
    # if [[ -r "${HOME}/.bashrc.d/00_colors.bash" ]]; then
    # 	  eval "$(dircolors -b "${HOME}/.bashrc.d/00_colors.bash")"
    # else
    #     eval "$(dircolors -b)"
    # fi
    alias ls='ls --color=auto --group-directories-first'
    alias la='ls --all --human-readable --color=auto --group-directories-first'
    alias ll='ls -l --all --human-readable --color=auto --group-directories-first'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto -in'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
else
    alias ls='ls --group-directories-first'
    alias la='ls --all --human-readable --group-directories-first'
    alias ll='ls -l --all --human-readable --group-directories-first'
    alias grep='grep -in'
fi

# Interactive & Verbose copy, move and remove commands
alias cp='cp -iv' mv='mv -iv' rm='rm -iv'

# Add --human-readable for various commands
alias du='du -h' df='df -h'
alias duthis='du -x --max-depth=1 | sort -hr|head'

# Midnight Commander Safe Terminal
# alias mcst='mc -a' # In case of malconfigured terminals
# Midnight Commander wrapper script
# alias mc='source /usr/share/mc/mc-wrapper.sh'

# Emacs alias
# EmaX No X11
alias exnx='emacs -nw'
# EmacsClient No X11
alias ecnx='emacsclient -t'
# EmacsClient Kill Daemon # Kill an emacs --daemon gracefully
alias eckd='emacsclient --eval="(kill-emacs)"'

# Various utils
alias bash_load_times='time bash -ic exit'
alias emacs_load_times="time emacs --eval='(kill-emacs)'"
alias term_geom='echo "${COLUMNS}x${LINES}"'

# calendar
alias cal='cal -m' # First Day Monday Calendars

# cloc
#alias cloc='cloc --by-file-by-lang'

# fonts for st
#alias st='st -g 80x25 -f SourceCodePro-Regular'

# NET
# alias fixnet='ping -c 1 www.gentoo.org||sudo rc-service NetworkManager restart'
alias test_net='ping -c 1 www.gentoo.org &> /dev/null;[[ $? == 0 ]] && echo "Net OK!" || echo "Net Down!"'

# Help wan-ip-howto
alias wip4='curl ipv4.whatismyip.akamai.com;echo'
alias wip6='curl ipv6.whatismyip.akamai.com;echo'

# ReMove Dead Links from current directory
alias rmdl='find -L . -name . -o -type d -prune -o -type l -exec rm -i {} +'

# Times table
# https://twitter.com/climagic/status/1187089764496891904
# Print a multiplication table. Great for those 3rd grader CLI users but also a great demo. :)
# alias multab='printf "%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n" $( echo {1..10}\*{1..10}\; | bc )'
# alias multab='printf "$(echo %3d$_{1..10})\n" $(echo {1..10}\*{1..10}\;|bc)'
alias propaideia='for x in {1..9}; do for y in $(seq 1 $x); do printf "%dx%d=%2d\t" $y $x $((y*x));done;printf "\n";done'
alias ttt='for x in {1..10}; do let tt="${x} * 10";for y in $(seq $x $x $tt);do printf "%4d" $y;done; printf "\n";done'

# https://twitter.com/liamosaur/status/506975850596536320
alias hug='sudo $(history -p \!\!)' # fuck='sudo $(history -p \!\!)' Political stupi... err correctess killed this one

# https://gist.github.com/seungwon0/802470
# curl -s http://whatthecommit.com | perl -p0e '($_)=m{<p>(.+?)</p>}s'
# curl -L -s http://whatthecommit.com/ | grep -A 1 "\"c" | tail -1 | sed 's/<p>//'
# curl -s http://whatthecommit.com/index.txt

# GIT
alias gcl='git clone'
alias gfc='git fetch'
alias gst='git status'
alias gdf='git diff'
alias gaa='git add --all'
alias gad='git add .'
alias gcm='git commit -m "$(curl -s http://whatthecommit.com/index.txt)"'
alias gps='git push'
alias gal='gaa && gcm && gps'
alias glp='git log -p'
alias glg='git log --graph --pretty="%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
# alias gco='git checkout'
# alias gpl='git pull --rebase'
# alias grb='git rebase'

# NETRIS
# https://git.sr.ht/~tslocum/netris?0.1.2
alias netris='ssh netris.rocketnine.space'

# Static, Good luck with high lvl lang implementations of lolcat.
# Recomended lolcat is: https://github.com/jaseg/lolcat
alias static='P=( " " █ ░ ▒ ▓ );while :;do printf "\e[$[RANDOM%LINES+1];$[RANDOM%COLUMNS+1]f${P[$RANDOM%5]}";done|lolcat'

# TermBin https://termbin.com/
alias termbin='nc termbin.com 9999'
