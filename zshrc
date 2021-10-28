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

alias v=vim
alias va=valgrind

eval $(dircolors -b ~/.dircolors/le_petit_chaperonrouge) > /dev/null 2> /dev/null

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
# functions
#

function fzf-ghq-cd-workspace() {
    local selected_dir=$(ghq list -p | fzf --query=${LBUFFER})
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

zle -N fzf-ghq-cd-workspace
bindkey '^w' fzf-ghq-cd-workspace

# search mpd playlist and play
function fmpc() {
  local song_position
  song_position=$(mpc -f "%position%) %artist% - %title%" playlist | \
    fzf --query="$1" --reverse --select-1 --exit-0 | \
    sed -n 's/^\([0-9]\+\)).*/\1/p') || return 1
  [ -n "$song_position" ] && mpc -q play $song_position
}

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
typeset -U path cdpath fpath manpath PATH

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
            style=38
            if [ "$1" = "bg" ]
            then
                (( style = 48 ))
            fi
            if [ "$2" = "6rgb" ]
            then
                (( code = 16 + $3 * 6 * 6 + $4 * 6 + $5 ))
                echo '%{\e[0;'"${style}"';5;'"${code}"'m%}'
            elif [ "$2" = "25gray" ]
            then
                (( code = 231 + $3 ))
                (( style = 5 ))
                echo '%{\e[0;'"${style}"';5;'"${code}"'m%}'
            elif [ "$2" = "24hex" ]
            then
                (( rv = `printf '%d\n' 0x\`echo $3 | cut -b 1,2\`` ))
                (( gv = `printf '%d\n' 0x\`echo $3 | cut -b 3,4\`` ))
                (( bv = `printf '%d\n' 0x\`echo $3 | cut -b 5,6\`` ))
                echo '%{\e['"${style}"';2;'"${rv}"';'"${gv}"';'"${bv}"'m%}'
            else
                echo unknown type $2
            fi
            # set bg or fg
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

    PROMPT="`colorcode fg 24hex 993745`"'> '"`colorcode reset`"
    case $KEYMAP in
        vicmd)
            PROMPT="`colorcode fg 24hex 94998a`"'> '"`colorcode reset`"
        ;;
        main|viins)
            PROMPT="`colorcode fg 24hex 7f0906`"'> '"`colorcode reset`"
        ;;  
    esac
    PROMPT2=". "
    RPROMPT="`colorcode fg 24hex 81553d`""`vcsinfo`""`colorcode reset`"
    SPROMPT="%F{$COLOR_BG_LPROMPT}%{$suggest%}(＠ﾟ△ﾟ%)ノ < もしかして %B%r%b かな? [そう!(y), 違う!(n),a,e] > "
}

function zle-line-init zle-keymap-select {
    zsh-update-prompt
    zle reset-prompt
}


zle -N zle-line-init
zle -N zle-keymap-select

zsh-update-prompt

#
# scripts
#

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.zshrc.local
