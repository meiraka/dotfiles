# Dotfiles

* Editor: Neovim
* Shell: Zsh
* Terminal: WezTerm
* Window Manager: Xmonad
* Panel: Polybar
* Compositor: Picom

## Install

```zsh
mkdir -p ~/.local/share
cd ~/.local/share
git clone git@github.com:meiraka/dotfiles.git
cd dotfiles
make
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
