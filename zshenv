export PATH=~/.cargo/bin:~/.local/bin:/usr/local/bin:~/bin:~/local/bin:$PATH:~/.local/opt/go/bin:~/.local/opt/node/bin:./node_modules/.bin:~/.local/opt/jdk/bin:~/.local/opt/zig
export LIBRARY_PATH=$HOME/.local/lib:/opt/homebrew/lib:$LIBRARY_PATH
export CPATH=$HOME/.local/include:/opt/homebrew/include:$CPATH
if [ -L ~/.local/opt/jdk ]; then
    export JAVA_HOME=~/.local/opt/jdk
fi
if [ -L ~/.local/opt/go ]; then
    export GOROOT=~/.local/opt/go
    export GOPATH=~/
fi
export GO111MODULE=on
export GOPRIVATE=\*.corp.\*.co.jp
export CLICOLOR=1
export LANG=ja_JP.UTF-8
export LC_LANG=${LANG}
export LC_ALL=${LANG}
if which nvim > /dev/null 2>&1; then
    export VISUAL=nvim
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
'
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS '--color=bg+:#3c3836,bg:#282828,spinner:#fabd2f,hl:#fabd2f,fg:#ebdbb2,header:#665c54,info:#83a598,pointer:#83a598,marker:#fe8019,fg+:#ebdbb2,prompt:#a89984,hl+:#fabd2f'"
