.PHONY: clean gitconfig help

DOT_SRC_SUBDIRS = config local/bin
DOT_SRC_IGNORES = Makefile bootstrap README.rst LICENSE local $(DOT_SRC_SUBDIRS)
DOT_SRC = $(filter-out $(DOT_SRC_IGNORES), $(wildcard *) $(wildcard $(addsuffix /*, $(DOT_SRC_SUBDIRS))))
DOT_DST_PREFIX = $(HOME)/.
DOT_DST_SUBDIRS = $(addprefix $(DOT_DST_PREFIX), $(DOT_SRC_SUBDIRS))
DOT_DST = $(addprefix $(DOT_DST_PREFIX), $(DOT_SRC))

# dotfiles

link: $(DOT_DST_SUBDIRS) $(DOT_DST) $(DOT_DST_PREFIX)vimrc $(DOT_DST_PREFIX)vim $(DOT_DST_PREFIX)gitconfig $(DOT_DST_PREFIX)zshrc.local ## create dotfiles link

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
	-@mv $@ $@bk && echo $@ was moved to $@bk
	ln -nsf $(abspath $<) $@

$(DOT_DST_SUBDIRS):
	mkdir -p $@

$(DOT_DST_PREFIX)zshrc.local:
	touch $(DOT_DST_PREFIX)zshrc.local
	chmod 600 $(DOT_DST_PREFIX)zshrc.local

# Add [include] directive in gitconfig
ifeq ($(shell grep $(DOT_DST_PREFIX)gitconfig.shared $(DOT_DST_PREFIX)gitconfig),)
.PHONY: $(DOT_DST_PREFIX)gitconfig
endif
$(DOT_DST_PREFIX)gitconfig:
	git config --global include.path $(DOT_DST_PREFIX)gitconfig.shared

# link neovim config to vim
$(DOT_DST_PREFIX)vimrc:
	ln -nsf $(DOT_DST_PREFIX)config/nvim/init.vim $(DOT_DST_PREFIX)vimrc
$(DOT_DST_PREFIX)vim:
	ln -nsf $(DOT_DST_PREFIX)config/nvim $(DOT_DST_PREFIX)vim

APPS = $(dir $(wildcard local/ports/*/Makefile))
APPS_NAME = $(patsubst local/ports/%/, %, $(APPS))

.PHONY: list install update $(APPS_NAME)
list:  ## show apps list
	@LIST="$(APPS_NAME)";\
		for x in $$LIST; do\
		echo "$$x";\
		done

install: ## [app name] install specified apps
	$(eval SUBTARGET := install)

update: ## [app name] update specified apps version
	$(eval SUBTARGET := update)

all: $(APPS_NAME) link ## create dotfiles link and install all apps

$(APPS_NAME): %: local/ports/%/
	$(MAKE) -C $< $(SUBTARGET)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
