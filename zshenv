export TERM="xterm-256color"
export PATH=~/.local/bin:/usr/local/bin:~/bin:~/local/bin:$PATH:~/.local/opt/go/bin:~/.local/opt/node/bin:./node_modules/.bin
export LD_LIBRARY_PATH=$HOME/lib:$HOME/local/lib:$HOME/.local/lib:$LD_LIBRARY_PATH
export _LIBUSER=y
export CPATH=/home/$_LIBUSER/include:$CPATH
export GOROOT=~/.local/opt/go
export GOPATH=~/
export GO111MODULE=on
export GOPRIVATE=\*.corp.\*.co.jp
export CLICOLOR=1
export LANG=ja_JP.UTF-8
export LC_LANG=${LANG}
export LC_ALL=${LANG}
if which vim > /dev/null 2>&1; then
    export VISUAL=vim
fi
export EDITOR="$VISUAL"
export QT_QPA_PLATFORMTHEME=gtk2
export MPD_HOST="moode.local"
export FZF_DEFAULT_OPTS='
  --height 50%
  --no-bold
  --color fg:#c0a0a0,bg:#362016,hl:#94998a,fg+:#c0a0a0,bg+:#402a20,hl+:#94998a
  --color info:#c10138,prompt:#9f424b,spinner:208,pointer:#7f0906,marker:#993745,header:#81553d
'
