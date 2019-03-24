# /etc/skel/.bashrc
esbrc="/etc/skel/.bashrc"
if [[ -f "${esbrc}" ]]; then
  source "${esbrc}"
fi

# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
# if [[ $- != *i* ]] ; then
# 	# Shell is non-interactive.  Be done now!
# 	return
# fi

# Put your fun stuff here.
gps="/usr/share/git/git-prompt.sh"
if [[ -r "${gps}" ]]; then # Git prompt
  source "${gps}"
fi

bcnf="${HOME}/git/utils/bash-insulter/src/bash.command-not-found"
if [[ -r "${bcnf}" ]]; then # Bash Insulter
  source "${bcnf}"
fi

brcd="${HOME}/.bashrc.d"
if [[ -d "${brcd}" ]]; then # Load files from ~/.bashrc.d
  for file in ${brcd}/*; do
    source "${file}"
  done
fi

#omb="${HOME}/.bashrc.osh-template"
#if [[ -f "${omb}" ]]; then # Load file omb
#  source "${omb}"
#fi

#bi="${HOME}/.bash_profile.template.bash"
#if [[ -f "${bi}" ]]; then # Load file omb
#  source "${bi}"
#fi

# omb="${HOME}/.bashrc.oh-my-bash"
# if [[ -f "${omb}" ]]; then # Load file omb
#   source "${omb}"
# fi

# bi="${HOME}/.bashrc.bash-it"
# if [[ -f "${bi}" ]]; then # Load file omb
#   "${bi}"
# fi
