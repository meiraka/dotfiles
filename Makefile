.PHONY: clean gitconfig help

DST_PREFIX = $(shell echo  ~/.)
SUBDIRS = config local/bin
IGNORE = Makefile bootstrap README.rst LICENSE local $(SUBDIRS)
SRC = $(filter-out $(IGNORE), $(wildcard *)) $(wildcard $(patsubst %, %/*, $(SUBDIRS)))
DOT_PATH = $(patsubst %, $(DST_PREFIX)%, $(SRC) $(SUBDIRSSRC))
DOT_SUBDIRS = $(patsubst %, $(DST_PREFIX)%, $(SUBDIRS))

# dotfiles

link: $(DOT_SUBDIRS) $(DOT_PATH) $(DST_PREFIX)vimrc $(DST_PREFIX)vim $(DST_PREFIX)gitconfig gitconfig ## create dotfiles link

clean:  # remove linked files
	@LIST="$(DOT_PATH)";\
		for x in $$LIST; do\
		if [ ! -L "$$x" ]; then\
		echo warning: "$$x" is not symbolic link\
		; else\
		rm "$$x";\
		fi\
		done

$(DOT_PATH): $(DST_PREFIX)%: %
	@if [ -e "$@" ]; then echo $@ already exists; exit 1; fi
	ln -s $(abspath $<) $@

$(DOT_SUBDIRS):
	mkdir -p $@

# Add [include] directive in gitconfig
GITCONFIG_APPLIED = $(shell grep .gitconfig.shared $(DST_PREFIX)gitconfig)
ifeq ($(GITCONFIG_APPLIED),)
gitconfig: $(DST_PREFIX)gitconfig
	if ! grep .gitconfig.shared $(DST_PREFIX)gitconfig 2> /dev/null > /dev/null; then\
		echo "[include]" >> $(DST_PREFIX)gitconfig;\
		echo "    path = $(DST_PREFIX)gitconfig.shared" >> $(DST_PREFIX)gitconfig;\
		fi
endif

$(DST_PREFIX)vimrc:
	ln -s $(DST_PREFIX)config/nvim/init.vim $(DST_PREFIX)vimrc
$(DST_PREFIX)vim:
	ln -s $(DST_PREFIX)config/nvim $(DST_PREFIX)vim
$(DST_PREFIX)gitconfig:
	touch $(DST_PREFIX)gitconfig

### apt ###
.PHONY: cli-apt desktop-apt
ifneq ($(shell which apt 2> /dev/null),)
ifneq ($(shell which -v dpkg 2> /dev/null),)
APT_REQUIRED_CLI = zsh git vim curl tmux automake build-essential pkg-config libevent-dev libncurses5-dev
APT_REQUIRED_DESKTOP = $(APT_REQUIRED_CLI) thunar thunar-archive-plugin thunar-media-tags-plugin tumbler-plugins-extra lxappearance nitrogen xmonad xmobar trayer gmrun pavucontrol sakura xfce4-power-manager xfce4-power-manager-plugins mupdf
APT_INSTALLED = $(shell dpkg -l | cut -d ' ' -f 3 | cut -d ':' -f 1 | sort | uniq)
APT_INSTALL_CLI = $(filter-out $(APT_INSTALLED), $(APT_REQUIRED_CLI))
APT_INSTALL_DESKTOP = $(filter-out $(APT_INSTALLED), $(APT_REQUIRED_DESKTOP))
ifneq ($(APT_INSTALL_CLI),)
cli-apt: ## install cli applications via apt
	sudo apt-get install -y $(APT_INSTALL_CLI)
endif
ifneq ($(APT_INSTALL_DESKTOP),)
desktop-apt: ## install desktop applications via apt
	sudo apt-get install -y $(APT_INSTALL_DESKTOP)
endif
endif
endif

### brew ###
.PHONY: cli-brew
ifneq ($(shell which brew 2> /dev/null),)
BREW_REQUIRED_CLI = libevent
BREW_INSTALLED = $(shell brew list)
BREW_INSTALL_CLI = $(filter-out $(BREW_INSTALLED), $(BREW_REQUIRED_CLI))
ifneq ($(BREW_INSTALL_CLI),)
cli-brew: ## install cli applications via brew
	brew install $(BREW_INSTALL_CLI)
endif
endif

### yum ###
.PHONY: cli-yum
ifneq ($(shell which yum 2> /dev/null),)
YUM_REQUIRED_CLI = autoconf automake byacc gcc-c++ libevent-devel
YUM_INSTALLED = $(shell yum list installed | cut -d ' ' -f 1 | cut -d '.' -f 1)
YUM_INSTALL_CLI = $(filter-out $(YUM_INSTALLED), $(YUM_REQUIRED_CLI))
ifneq ($(YUM_INSTALL_CLI),)
cli-yum: ## install cli applications via yum
	yum install $(YUM_INSTALL_CLI)
endif
endif

### ports ###

APPS = $(dir $(wildcard local/ports/*/Makefile))
.PHONY: install $(APPS)

$(APPS): cli-apt cli-brew
	$(MAKE) -C $@

cli: $(APPS) ## install cli applications
desktop: desktop-apt ## install desktop applications

all: link cli  ## execute all targets

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
