export TERM="xterm-256color"
export PATH=~/.local/bin:/usr/local/bin:~/bin:~/local/bin:$PATH:~/.local/opt/go/bin:~/.local/opt/node/bin:./node_modules/.bin:~/.local/opt/jdk/bin:~/.local/opt/zig
export LIBRARY_PATH=$HOME/.local/lib:/opt/homebrew/lib:$LIBRARY_PATH
export JAVA_HOME=~/.local/opt/jdk
export CPATH=$HOME/.local/include:/opt/homebrew/include:$CPATH
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

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GLFW_IM_MODULE=ibus kitty
export EDITOR="$VISUAL"
export QT_QPA_PLATFORMTHEME=qt5ct
export MPD_HOST="moode.local"
export FZF_DEFAULT_OPTS='
  --height 50%
  --color=bg+:#1e2132,spinner:#84a0c6,hl:#6b7089,fg:#c6c8d1,header:#6b7089,info:#b4be82,pointer:#84a0c6,marker:#84a0c6,fg+:#c6c8d1,prompt:#84a0c6,hl+:#84a0c6
'
