.PHONY: clean gitconfig help

DOT_SRC_SUBDIRS = config local/bin
DOT_SRC_IGNORES = Makefile bootstrap README.rst LICENSE local $(DOT_SRC_SUBDIRS)
DOT_SRC = $(filter-out $(DOT_SRC_IGNORES), $(wildcard *) $(wildcard $(addsuffix /*, $(DOT_SRC_SUBDIRS))))
DOT_DST_PREFIX = $(HOME)/.
DOT_DST_SUBDIRS = $(patsubst %, $(DOT_DST_PREFIX)%, $(DOT_SRC_SUBDIRS))
DOT_DST = $(addprefix $(DOT_DST_PREFIX), $(DOT_SRC))

# dotfiles

link: $(DOT_DST_SUBDIRS) $(DOT_DST) $(DOT_DST_PREFIX)vimrc $(DOT_DST_PREFIX)vim $(DOT_DST_PREFIX)gitconfig ## create dotfiles link

clean:  # remove linked files
	@LIST="$(DOT_DST)";\
		for x in $$LIST; do\
		if [ ! -L "$$x" ]; then\
		echo warning: "$$x" is not symbolic link\
		; else\
		rm "$$x";\
		fi\
		done

$(DOT_DST): $(DOT_DST_PREFIX)%: %
	ln -nsf $(abspath $<) $@

$(DOT_DST_SUBDIRS):
	mkdir -p $@

# Add [include] directive in gitconfig
ifeq ($(shell grep .gitconfig.shared $(DOT_DST_PREFIX)gitconfig),)
.PHONY: $(DOT_DST_PREFIX)gitconfig
endif
$(DOT_DST_PREFIX)gitconfig:
	git config --global include.path /home/mei/.gitconfig.shared

# link neovim config to vim
$(DOT_DST_PREFIX)vimrc:
	ln -nsf $(DOT_DST_PREFIX)config/nvim/init.vim $(DOT_DST_PREFIX)vimrc
$(DOT_DST_PREFIX)vim:
	ln -nsf $(DOT_DST_PREFIX)config/nvim $(DOT_DST_PREFIX)vim

### apt ###
.PHONY: cli-apt desktop-apt
ifneq ($(shell which apt 2> /dev/null),)
ifneq ($(shell which -v dpkg 2> /dev/null),)
APT_REQUIRED_CLI = zsh git vim curl tmux automake build-essential pkg-config libevent-dev libncurses5-dev gettext
APT_REQUIRED_DESKTOP = $(APT_REQUIRED_CLI) thunar thunar-archive-plugin thunar-media-tags-plugin tumbler-plugins-extra lxappearance nitrogen xmonad xmobar trayer gmrun pavucontrol sakura xfce4-power-manager xfce4-power-manager-plugins mupdf qt5-style-plugins
APT_INSTALLED = $(shell dpkg -l | cut -d ' ' -f 3 | cut -d ':' -f 1 | sort | uniq)
APT_INSTALL_CLI = $(filter-out $(APT_INSTALLED), $(APT_REQUIRED_CLI))
APT_INSTALL_DESKTOP = $(filter-out $(APT_INSTALLED), $(APT_REQUIRED_DESKTOP))
ifneq ($(APT_INSTALL_CLI),)
cli-apt:
	sudo apt-get install -y $(APT_INSTALL_CLI)
endif
ifneq ($(APT_INSTALL_DESKTOP),)
desktop-apt:
	sudo apt-get install -y $(APT_INSTALL_DESKTOP)
endif
endif
endif

### brew ###
.PHONY: cli-brew
ifneq ($(shell which brew 2> /dev/null),)
BREW_REQUIRED_CLI = libevent autoconf automake libtool
BREW_INSTALLED = $(shell brew list)
BREW_INSTALL_CLI = $(filter-out $(BREW_INSTALLED), $(BREW_REQUIRED_CLI))
ifneq ($(BREW_INSTALL_CLI),)
cli-brew:
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
cli-yum:
	sudo yum install -y $(YUM_INSTALL_CLI)
endif
endif

### ports ###

APPS = $(dir $(wildcard local/ports/*/Makefile))
.PHONY: install $(APPS)

$(APPS): cli-apt cli-brew cli-yum
	$(MAKE) -C $@ $(SUBTARGET)

.PHONY: update
update:
	$(eval SUBTARGET := update)

cli: $(APPS) ## install cli applications
	@touch .cli
desktop: desktop-apt ## install desktop applications

all: link cli  ## execute all targets

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
