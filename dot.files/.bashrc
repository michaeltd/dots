# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH="${HOME}/bin:${PATH}"

source /home/paperjam/.cargo/env

export GOPATH="${HOME}/GO"


PS1="\n\[\e[0;34m\]┌─[\[\e[1;36m\u\e[0;34m\]]──[\e[1;37m\w\e[0;34m]──[\[\e[1;36m\]${HOSTNAME%%.*}\[\e[0;34m\]]\[\e[1;35m\]: \$\[\e[0;34m\]\n\[\e[0;34m\]└────╼ \[\e[1;35m\]>> \[\e[00;00m\]"

PS2='$(if [[ $? == 0 ]]; then echo "\[\033[01;32m\]\342\234\223"; else echo "\[\033[01;31m\]\342\234\227"; fi) \[\033[01;31m\]\u\[\033[01;34m\]\[\033[1;33m\]@\[\033[01;36m\] \w $ \[\033[00m\]'

# TERMCAP Setup
# enter blinking mode - red
# export LESS_TERMCAP_mb=$(printf '\e[01;31m')
# enter double-bright mode - bold, magenta
# export LESS_TERMCAP_md=$(printf '\e[01;35m')
# turn off all appearance modes (mb, md, so, us)
# export LESS_TERMCAP_me=$(printf '\e[0m')
# leave standout mode
# export LESS_TERMCAP_se=$(printf '\e[0m')
# enter standout mode - green
# export LESS_TERMCAP_so=$(printf '\e[01;32m')
# leave underline mode
# export LESS_TERMCAP_ue=$(printf '\e[0m')
# enter underline mode - blue
# export LESS_TERMCAP_us=$(printf '\e[04;34m')

# PS1 Setup
PROMPT_COMMAND=__prompt_command

__prompt_command() {
    local EXITCODE="$?"

    local HOSTCOLOR="5"
    local USERCOLOR="3"
    local PATHCOLOR="4"

    PS3="\e[3${HOSTCOLOR}m \h  \e[3${USERCOLOR}m \u  \e[3${PATHCOLOR}m \w  \n";

    if [ $EXITCODE == 0 ]; then
        PS3+="\e[32m\$ \e[0m";
    else
        PS3+="\e[31m\$ \e[0m";
    fi
}


_PROMPT() {
  _EXIT_STATUS=$?
  [ $_EXIT_STATUS != 0 ] && _EXIT_STATUS_STR=" \[\033[38;5;7m\][\[$(tput sgr0)\]\[\033[38;5;9m\]$_EXIT_STATUS\[$(tput sgr0)\]\[\033[38;5;7m\]]\[$(tput sgr0)\]"

	_BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! $_BRANCH == "" ]
	then
		_BRANCH_STR="[\[$(tput sgr0)\]\[\033[38;5;11m\]$_BRANCH\[$(tput sgr0)\]\[\033[38;5;7m\]]"
	else
		_BRANCH_STR=""
	fi

  PS4="\[\033[38;5;14m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;6m\]\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;7m\]╺─╸\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;7m\][\[$(tput sgr0)\]\[\033[38;5;14m\]\W\[$(tput sgr0)\]\[\033[38;5;7m\]]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;7m\]$_BRANCH_STR\[$(tput sgr0)\]\[\033[38;5;15m\] \n\[$(tput sgr0)\]\[\033[38;5;7m\][\[$(tput sgr0)\]\[\033[38;5;11m\]\A\[$(tput sgr0)\]\[\033[38;5;7m\]]\[$(tput sgr0)\]\[\033[38;5;15m\]$_EXIT_STATUS_STR \[$(tput sgr0)\]\[\033[38;5;7m\]>>\[$(tput sgr0)\] "
  unset _EXIT_STATUS_STR
	unset _EXIT_STATUS
	unset _BRANCH_STR
	unset _BRANCH
}

PROMPT_COMMAND=_PROMPT

PS5="\[\e[01;34m\]┎ \w\n\[\e[01;34m\]┖ \`echo \"scale=2; \$(cut -d' ' -f2 </proc/loadavg) /    \$(grep ^processor </proc/cpuinfo | wc -l)\" | bc\` \[\e[01;32m\]\`[ \u = \"$ME\" ]     ||{ [ \u = root ] && echo -n \"\[\e[01;31m\]\"; } || echo -n \"\[\e[01;37m\]\u \"\`\[\e[01;32m\]at \h \[\e[01;34m\]\\$\[\e[00m\] "


# Load files from ~/.bashrc.d
if [ -d ${HOME}/.bashrc.d ]; then
    for file in ${HOME}/.bashrc.d/*; do
        # echo "$file yes" #
        source "$file";
    done
fi
