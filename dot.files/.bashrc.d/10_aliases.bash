# ~/.bashrc.d/aliases.bash
#
# Perfect alias candidates are one liners or functions that take no arguments.

#shellcheck shell=bash

if [[ -x "$(type -P dircolors)" ]]; then
    # Color support
    if [[ -r "${HOME}/.bashrc.d/00_colors.bash" ]]; then
	eval "$(dircolors -b "${HOME}/.bashrc.d/00_colors.bash")"
    else
	eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto --group-directories-first'
    alias la='ls --all --human-readable --color=auto --group-directories-first'
    alias ll='ls -l --all --human-readable --color=auto --group-directories-first'
    # alias ls='ls --color=auto'
    # alias la='ls --all --human-readable --color=auto'
    # alias ll='ls -l --all --human-readable --color=auto'
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

alias du='du -h'
alias duthis='du -h -x --max-depth=1 | sort -hr|head'
alias df='df -h'

# Package Search, Install, Remove
# Distro Update, Upgrade, Cleanup
if type -P apt-get &> /dev/null; then
    alias psearch='apt search' pinstall='sudo apt-get install' \
	  premove='sudo apt-get remove --purge'
    alias dupdate='sudo apt-get update' dupgrade='sudo apt-get dist-upgrade' \
	  dcleanup='sudo apt-get autoremove'
elif type -P zypper &> /dev/null; then
    alias psearch='zypper search' pinstall='sudo zypper install' \
	  premove='sudo zypper remove --clean-deps'
    alias dupdate='sudo zypper refresh' dupgrade='sudo zypper update' \
	  dcleanup='sudo zypper rm -u'
elif type -P yum &> /dev/null; then
    alias psearch='yum search' pinstall='sudo yum install' \
	  premove='sudo yum remove'
    alias dupdate='sudo yum check-update' dupgrade='sudo yum update' \
	  dcleanup='sudo yum autoremove'
elif type -P pacman &> /dev/null; then
    alias psearch='pacman -Ss' pinstall='sudo pacman -S' \
	  premove='sudo pacman -R'
    alias dupdate='sudo pacman -Sy' dupgrade='sudo pacman -Syu' \
	  dcleanup='sudo pacman -Rsn'
elif type -P emerge &> /dev/null; then
    alias psearch='emerge -s' pinstall='sudo emerge -av' \
	  premove='sudo emerge -avC'
    alias dupdate='sudo emerge --sync' dupgrade='sudo emerge -avuND @world' \
	  dcleanup='sudo emerge --ask --depclean'
elif type -P pkg &> /dev/null; then
    alias psearch='pkg -o search' pinstall='sudo pkg install' \
	  premove='sudo pkg remove'
    alias dupdate='sudo pkg update' dupgrade='sudo pkg upgrade' \
	  dcleanup='sudo pkg autoremove'
fi

# Midnight Commander Safe Terminal
# alias mcst='mc -a' # In case of malconfigured terminals
# alias mc='source /usr/share/mc/mc-wrapper.sh'

# Emacs alias
alias exnx='emacs -nw' # EmaX No X11
alias ecnx='emacsclient -t' # EmacsClient No X11 # No use for -a switch as we exported ALTERNATE_EDITOR in variables
alias eckd='emacsclient --eval="(kill-emacs)"' # EmacsClient Kill Daemon # Kill an emacs --daemon gracefully

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
# alias gfc='git fetch'
alias gst='git status'
alias gdf='git diff'
# alias gaa='git add --all'
alias gad='git add .'
alias gcm='git commit -m "$(curl -s http://whatthecommit.com/index.txt)"'
#alias gitcm='git commit -m "$(wget -q -O - http://whatthecommit.com/index.txt)"'
alias gps='git push'
alias gal='gad && gcm && gps'
alias glp='git log -p'
alias glg='git log --graph --pretty="%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
# alias gco='git checkout'
# alias gpl='git pull --rebase'
# alias grb='git rebase'

# NETRIS
# https://git.sr.ht/~tslocum/netris?0.1.2
alias netris='ssh netris.rocketnine.space'

# Static
alias static='P=( " " █ ░ ▒ ▓ );while :;do printf "\e[$[RANDOM%LINES+1];$[RANDOM%COLUMNS+1]f${P[$RANDOM%5]}";done|lolcat'

# TermBin https://termbin.com/
alias termbin='nc termbin.com 9999'
