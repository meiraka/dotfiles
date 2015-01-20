#
# alias
#
alias x=exit
alias reload="source ~/.zshrc"
if [ `uname` = Darwin ]; then
  #BSD ls
  alias ls="ls -G"
else
  #GNU ls
  alias ls="ls --color=auto"
fi

#
# env
#
export TERM="xterm-256color"
export PATH=~/local/bin:$PATH:~/bin
export CLICOLOR=1
export LANG=ja_JP.UTF-8
export LC_LANG=${LANG}
export LC_ALL=${LANG}
export EDITOR=vi
export MPD_HOST="voyage.local"

if which ~/local/tmp/dircolors > /dev/null; then
  mkdir -p ~/local/tmp
  python ~/local/bin/dir_colors.py > ~/local/tmp/dir_colors
  eval $(dircolors -b ~/local/etc/dir_colors) > /dev/null 2> /dev/null
fi

if [ -n "$LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

bindkey -v

# backspace removes cursor backword
zle -A .backward-kill-word vi-backward-kill-word
zle -A .backward-delete-char vi-backward-delete-char
# delete removes cursor forward
bindkey "[3~" delete-char

#
# ssh
#
SOCK="/tmp/ssh-agent-$USER"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
    rm -f $SOCK
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
fi

#
# history
#
HISTFILE="$HOME/.zhistory"
HISTSIZE=100000
SAVEHIST=100000

setopt correct
setopt hist_ignore_dups
setopt share_history
setopt nonomatch

function history-all { history -E 1 }
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# control + p or cursor up key to search backword
bindkey ""    history-beginning-search-backward-end
bindkey "[A"  history-beginning-search-backward-end
# control + n or cursor down key to search forward
bindkey ""    history-beginning-search-forward-end
bindkey "[B"  history-beginning-search-forward-end

zstyle ':completion:*:default' menu select=1

#
# prompt
#
setopt transient_rprompt
setopt print_exit_value
setopt prompt_subst

function zsh-update-prompt {
    function colorcode {
        if [ "$1" = "reset" ]
        then
            echo '%{\e[m%}'
        else
            # generate color code
            code=-1
            if [ "$2" = "6rgb" ]
            then
                (( code = 16 + $3 * 6 * 6 + $4 * 6 + $5 ))
            elif ["$2" = "25gray" ]
            then
                (( code = 231 + $3 ))
            else
                echo unknown type $2
            fi
            # set bg or fg
            if [ "$1" = "bg" ]
            then
                echo '%{\e[0;48;5;'"${code}"'m%}'
            else
                echo '%{\e[0;38;5;'"$code"'m%}'
            fi
        fi
    }

    function vcsinfo {
        if git status > /dev/null 2> /dev/null; then
            VCS_TEXT="git"
            VCS_REMOTE_TEXT=`git config --list | grep "origin.url" | cut -d"=" -f 2`
            VCS_BRANCH_TEXT=`git branch | grep "\*" | sed "s/\* //"`
        fi
        if [ "${VCS_TEXT}" = "" ]; then
        else
            echo "${VCS_REMOTE_TEXT} ${VCS_BRANCH_TEXT}"
        fi
    }

    PROMPT="`colorcode fg 6rgb 4 0 0`"'> '"`colorcode reset`"
    case $KEYMAP in
        vicmd)
            PROMPT="`colorcode fg 6rgb 4 2 0`"'> '"`colorcode reset`"
        ;;
        main|viins)
            PROMPT="`colorcode fg 6rgb 4 0 0`"'> '"`colorcode reset`"
        ;;  
    esac
    PROMPT2=". "
    RPROMPT="`colorcode fg 6rgb 2 2 2`""`vcsinfo`""`colorcode reset`"
    SPROMPT="%F{$COLOR_BG_LPROMPT}%{$suggest%}(＠ﾟ△ﾟ%)ノ < もしかして %B%r%b かな? [そう!(y), 違う!(n),a,e] > "
}

function zle-line-init zle-keymap-select {
    zsh-update-prompt
    zle reset-prompt
}


zle -N zle-line-init
zle -N zle-keymap-select

zsh-update-prompt
