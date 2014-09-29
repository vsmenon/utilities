# ~/.bashrc: executed by bash(1) for non-login shells.

# If running interactively, then:
if [ "$PS1" ]; then

    # enable color support of ls and also add handy aliases
    alias rm='rm -i'
    alias mv='mv -i'
    alias cp='cp -i'
    alias s='cd ..'
    alias d='ls'
    alias p='cd -'
    alias cdd='cd'
    alias soc='source ~/.bashrc'

    alias gitbr='git config --get-regexp branch.*.rietveldissue'

    # Mac
    alias aquamacs='/Applications/Aquamacs.app/Contents/MacOS/Aquamacs'

    # set a fancy prompt
    PS1='[\H:`pwd`] '
fi

export EDITOR=emacs

###########################################################################
# Set Other

# Chromium build tools
export PATH=~/depot_tools:$PATH

# Dart SDK
export PATH=$PATH:~/dart/dart-sdk/bin

# Enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
      . /etc/bash_completion
fi

export PS1='[\H:`pwd`] '
