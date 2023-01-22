autoload -Uz compinit
compinit
#
# alias
#
alias x=exit
alias vim=nvim
alias reload="source ~/.zshrc"
if [ `uname` = Darwin ]; then
  if which gls >/dev/null 2>&1; then
    # GNU ls
    alias ls="gls --color=auto"
    eval $(gdircolors -b ~/.dir_colors 2> /dev/null)
  else
    #BSD ls
    alias ls="ls -G"
  fi
else
  #GNU ls
  alias ls="ls --color=auto"
  eval $(dircolors -b ~/.dir_colors 2> /dev/null)
fi

alias v=vim
alias va=valgrind

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

source ~/.zshprompt
#
# scripts
#

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.local/bin/kubectl ] && source <(~/.local/bin/kubectl completion zsh)
source ~/.zshrc.local

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

#
# plugins
#

# Additional completion
zinit light zsh-users/zsh-completions
# move to git base dir
zinit light mollifier/cd-gitroot
alias cdu=cd-gitroot
