#!/usr/bin/env bash

# added by Anaconda3 5.3.0 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/paperjam/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/home/paperjam/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/paperjam/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/home/paperjam/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

export PATH="${HOME}/anaconda3/bin:${PATH}"
#export PATH+=":~/anaconda3/bin"

cd ~/anaconda3

xterm
