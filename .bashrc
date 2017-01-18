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
    alias atom='/Applications/Atom.app/Contents/MacOS/Atom'

    # set a fancy prompt
    PS1='[\H:`pwd`] '
fi

export EDITOR=emacs

###########################################################################

# Save all commands to file.  Precede with timestamp, hostname, shell pid,
# and return code of last command
export HISTTIMEFORMAT="%Y.%m.%d %H:%M:%S "

log_bash_eternal_history()
{
  local rc=$?
  [[ $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$ ]]
  local date_part="${BASH_REMATCH[1]}"
  local command_part="${BASH_REMATCH[2]}"
  if [ "$command_part" != "$ETERNAL_HISTORY_LAST" -a "$command_part" != "ls" -a "$command_part" != "ll" ]
  then
    echo $date_part $HOSTNAME $$ $rc "$command_part" >> ~/.bash_eternal_history
    export ETERNAL_HISTORY_LAST="$command_part"
  fi
}

PROMPT_COMMAND="log_bash_eternal_history"

###########################################################################
# Set Other

export PATH=~/utilities/bin:$PATH

# Chromium build tools
export PATH=~/depot_tools:$PATH

# Dart SDK
export PATH=$PATH:~/dart/dart-sdk/bin

# Enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
      . /etc/bash_completion
fi

export PS1='[\H:`pwd`] '
