# Dotfiles

* Editor: Neovim
* Shell: Zsh
* Terminal: WezTerm
* Window Manager: Xmonad
* Panel: Polybar
* Compositor: Picom
* Notificator: dunst

## Install

```zsh
mkdir -p ~/.local/share
cd ~/.local/share
git clone git@github.com:meiraka/dotfiles.git
cd dotfiles
make
```

### Dependencies
#### EndeavourOS

```sh
sudo pacman -S vivaldi wezterm xmonad xmonad-contrib gmrun polybar dunst dmenu nitrogen picom blueman
sudo pacman -S base-devel cmake unzip ninja curl
```

### macOS

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install ninja cmake gettext curl
```

## Commands
### dotfiles

dotfiles manager(WIP)

### app

Simple package manager written in Makefile.

```
usage:
	app <commands> [arguments]

commands:
all                                      install all apps
install [VERSION=version] PACKAGE...     install specified apps
list                                     show apps list
update PACKAGE...                        update specified apps version
version PACKAGE...                       show install app version
versions PACKAGE...                      show available versions
```
