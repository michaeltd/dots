# ~/.bashrc.d/aliases
#
# Perfect alias candidates are one liners or functions that take no arguments.

if [ -x /usr/bin/dircolors ]; then
    # Color support
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
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

alias du='du -h'
alias df='df -h'

# Package Search, Install, Remove
# Distro Update, Upgrade, Cleanup
if [[ -n $(which emerge 2> /dev/null) ]]; then
    alias psearch='emerge -s' pinstall='sudo emerge -av' premove='sudo emerge -avC'
    alias dupdate='sudo emerge --sync' dupgrade='sudo emerge -avuND --with-bdeps=y @world' dcleanup='sudo emerge --ask --depclean'
elif [[ -n $(which pacman 2> /dev/null) ]]; then
    alias psearch='pacman -Ss' pinstall='sudo pacman -S' premove='sudo pacman -R'
    alias dupdate='sudo pacman -Sy' dupgrade='sudo pacman -Syu' dcleanup='sudo pacman -Rsn'
elif [[ -n $(which apt-get 2> /dev/null) ]]; then
    alias psearch='apt search' pinstall='sudo apt-get install --install-suggests' premove='sudo apt-get premove --purge'
    alias dupdate='sudo apt-get update' dupgrade='sudo apt-get dist-upgrade' dcleanup='sudo apt-get autoremove'
elif [[ -n $(which zypper 2> /dev/null) ]]; then
    alias psearch='zypper search' pinstall='sudo zypper install' premove='sudo zypper remove --clean-deps'
    alias dupdate='sudo zypper refresh' dupgrade='sudo zypper update' dcleanup='sudo zypper rm -u'
elif [[ -n $(which yum 2> /dev/null) ]]; then
    alias psearch='yum search' pinstall='sudo yum install' premove='sudo yum remove'
    alias dupdate='sudo yum check-update' dupgrade='sudo yum update' dcleanup='sudo yum autoremove'
fi

# Mount
alias mntc='sudo mount -t auto /dev/sdc1 /mnt/thumb'
alias mntd='sudo mount -t auto /dev/sdd1 /mnt/thumb'
alias mnte='sudo mount -t auto /dev/sde1 /mnt/thumb'
alias mntf='sudo mount -t auto /dev/sdf1 /mnt/thumb'

# PC
alias halt='sudo shutdown -h' # Use with "now", "HH:MM" or any other valid (by shutdown) TIME construct.
alias reboot='sudo shutdown -r' # as above

# Midnight Commander Safe Terminal
alias mcst='mc -a' # In case of malconfigured terminals

# URxvt transparency
alias urxvt='urxvt -depth 32 -bg rgba:0000/0000/0000/aaaa'

# Emacs in terminal
alias exnx='emacs -nw' # EmaX No X11
# emacsclient
alias ec='emacsclient -c' # Emacs Client
alias ecnx='emacsclient -t' # Emacs Client No X11 # No use for -a switch as we exported ALTERNATE_EDITOR in variables
alias kexd='emacsclient -e "(kill-emacs)"' # Kill EmaX Daemon # Kill an emacs --daemon gracefully


# calendar
alias cal='cal -m' # First Day Monday Calendars

# cloc
alias cloc='cloc --by-file-by-lang'

# NET
alias fixnet='ping -c 1 www.microsoft.com||sudo rc-service dhcpcd restart'
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'

# ReMove Dead Links from current directory
alias rmdl='find -L . -name . -o -type d -prune -o -type l -exec rm -i {} +'

# Math time tables
alias propaideia='for a in {1..9}; do for b in $(seq 1 $a); do printf "%dx%d=%2d\t" $b $a $((b*a));done;printf "\n";done'
alias ttt='for a in {1..10}; do let tt="${a} * 10";for b in $(seq $a $a $tt);do printf "%4d" $b;done; printf "\n";done'

# https://twitter.com/liamosaur/status/506975850596536320
#alias fuck='sudo $(history -p \!\!)'

# GIT
# alias gcl='git clone'
# alias gfc='git fetch'
alias gst='git status'
# alias gdf='git diff'
# alias gaa='git add --all'
alias gad='git add .'
alias gcm='git commit -m'
alias gps='git push'
alias glp='git log -p'
alias glg='git log --graph --pretty="%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
# alias gco='git checkout'
# alias gpl='git pull --rebase'
# alias grb='git rebase'
