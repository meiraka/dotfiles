source ~/.zshenv

export PATH="$HOME/.cargo/bin:$PATH"
if [ -f /opt/homebrew/bin/brew ]; then
    eval $(/opt/homebrew/bin/brew shellenv)
fi
