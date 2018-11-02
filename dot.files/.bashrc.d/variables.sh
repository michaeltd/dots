# ~/.bashrc.d/variables
#
# Set environment variables

# Used by emacsclient in case of no daemon found.
export ALTERNATE_EDITOR=$(which micro 2> /dev/null||which vi 2> /dev/null||which nano 2> /dev/null)

if [[ -n "${DISPLAY}" ]]; then
  unset 'EDITOR'
  if [[ -x $(which emacs 2> /dev/null) ]]; then
    export VISUAL="emacsclient --alternate-editor=emacs -c"
  elif [[ -x $(which gvim 2> /dev/null) ]]; then
    export VISUAL="gvim"
  else
    export VISUAL="xterm -e ${ALTERNATE_EDITOR}"
  fi
  export BROWSER=$(which firefox 2> /dev/null||which seamonkey 2> /dev/null)
else
  unset 'VISUAL'
  if [[ -x $(which emacs 2> /dev/null) ]]; then
    export EDITOR="emacsclient --alternate-editor=emacs -t"
  elif [[ -x $(which vim 2> /dev/null) ]]; then
    export EDITOR="vim"
  else
    export EDITOR="${ALTERNATE_EDITOR}"
  fi
  export BROWSER=$(which w3m 2> /dev/null||which links 2> /dev/null||which lynx 2> /dev/null)
fi

# most > less > more in order of preference
export PAGER=$(which most 2> /dev/null||which less 2> /dev/null||which more 2> /dev/null)

# manpager in case you'd like your manpages in your favorite editor
# export MANPAGER="env MAN_PN=1 vim -M +MANPAGER -"

export LANG="en_US.utf8"
export LC_COLLATE="C"

export HISTCONTROL=ignoreboth
export HISTSIZE=99999
export HISTFILESIZE=99999

export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWSTASHSTATE=yes
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=yes

export OPT="${HOME}/opt"
export JAVA="/opt/java"
export JAVA_HOME="${JAVA}"
export ANT="${HOME}/opt/ant"
export MAVEN="${HOME}/opt/maven"
export GRADLE="${HOME}/opt/gradle"
export GOPATH="${HOME}/go"
export NODE="/opt/nodejs"
export MONGODB="/opt/mongodb"
export SCALA_HOME="/opt/scala"

# Path with += op and each tool in it's own line for practical reasons
export PATH+=":${OPT}/bin"
export PATH+=":${HOME}/bin"
export PATH+=":${JAVA_HOME}/bin"
export PATH+=":${ANT}/bin"
export PATH+=":${MAVEN}/bin"
export PATH+=":${GRADLE}/bin"
export PATH+=":${GOPATH}/bin"

if [[ -d "${HOME}/.cargo" ]]; then
  export PATH+=":${HOME}/.cargo/bin"
fi

export PATH+=":${NODE}/bin"
export PATH+=":${MONGODB}/bin"
export PATH+=":${SCALA_HOME}/bin"
# export PATH+=":${HOME}/.racket/7.0.0.9/bin"

# JAVA classpath
export CLASSPATH+=":./"
export CLASSPATH+=":${JAVA}/lib"
export CLASSPATH+=":${ANT}/lib"
export CLASSPATH+=":${MAVEN}/lib"