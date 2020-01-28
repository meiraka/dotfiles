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
else
gitconfig: $(DST_PREFIX)gitconfig
endif

# Link nvim/init.vim to .vimrc
$(DST_PREFIX)vimrc:
	ln -s $(DST_PREFIX)config/nvim/init.vim $(DST_PREFIX)vimrc

# Link nvim to .vim
$(DST_PREFIX)vim:
	ln -s $(DST_PREFIX)config/nvim $(DST_PREFIX)vim

# Make gitconfig
$(DST_PREFIX)gitconfig:
	touch $(DST_PREFIX)gitconfig

# apps

APPS = $(wildcard local/ports/*)
.PHONY: install $(APPS)

$(APPS):
	$(MAKE) -C $@

### apt ###
.PHONY: apt-cli apt-desktop
ifneq ($(shell which apt),)
ifneq ($(shell which dpkg),)
APT_REQUIRED_CLI = zsh git automake build-essential pkg-config libevent-dev libncurses5-dev
APT_REQUIRED_DESKTOP = $(APT_REQUIRED_CLI) thunar thunar-archive-plugin thunar-media-tags-plugin tumbler-plugins-extra lxappearance nitrogen xmonad xmobar trayer gmrun pavucontrol sakura xfce4-power-manager xfce4-power-manager-plugins mupdf
APT_INSTALLED = $(shell dpkg -l | cut -d ' ' -f 3 | cut -d ':' -f 1 | sort | uniq)
APT_PREFIX = apt/
APT_INSTALL_CLI = $(patsubst %, $(APT_PREFIX)%, $(filter-out $(APT_INSTALLED), $(APT_REQUIRED_CLI)))
APT_INSTALL_DESKTOP = $(patsubst %, $(APT_PREFIX)%, $(filter-out $(APT_INSTALLED), $(APT_REQUIRED_DESKTOP)))
.PHONY: $(APT_INSTALL_CLI) $(APT_INSTALL_DESKTOP)
ifneq ($(APT_INSTALL_CLI),)
apt-cli: ## install cli applications via apt
	sudo apt install -y $(patsubst $(APT_PREFIX)%, %, $(APT_INSTALL_CLI))
endif
ifneq ($(APT_INSTALL_DESKTOP),)
apt-desktop: ## install desktop applications via apt
	sudo apt install -y $(patsubst $(APT_PREFIX)%, %, $(APT_INSTALL_DESKTOP))
endif
endif
endif

cli: apt-cli  ## install cli applications

all: link cli  ## execute all targets

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
