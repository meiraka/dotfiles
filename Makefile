.PHONY: clean gitconfig help

DOT_SRC_SUBDIRS = config local/bin
DOT_SRC_IGNORES = Makefile bootstrap README.md LICENSE local $(DOT_SRC_SUBDIRS)
DOT_SRC = $(filter-out $(DOT_SRC_IGNORES), $(wildcard *) $(wildcard $(addsuffix /*, $(DOT_SRC_SUBDIRS))))
DOT_DST_PREFIX = $(HOME)/.
DOT_DST_SUBDIRS = $(addprefix $(DOT_DST_PREFIX), $(DOT_SRC_SUBDIRS))
DOT_DST = $(addprefix $(DOT_DST_PREFIX), $(DOT_SRC))

# dotfiles

link: $(DOT_DST_SUBDIRS) $(DOT_DST) $(DOT_DST_PREFIX)gitconfig $(DOT_DST_PREFIX)zshrc.local $(DOT_DST_PREFIX)local/share/backgrounds/sys ## create dotfiles link

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
	@if [ -f "$@" -o -d "$@" ]; then mv $@ $@bk; echo "$@" was moved to "$@bk"; fi
	ln -nsf $(abspath $<) $@

$(DOT_DST_SUBDIRS):
	mkdir -p $@

$(DOT_DST_PREFIX)zshrc.local:
	touch $(DOT_DST_PREFIX)zshrc.local
	chmod 600 $(DOT_DST_PREFIX)zshrc.local

# Add [include] directive in gitconfig
ifeq ($(shell grep $(DOT_DST_PREFIX)gitconfig.shared $(DOT_DST_PREFIX)gitconfig 2> /dev/null),)
.PHONY: $(DOT_DST_PREFIX)gitconfig
endif
$(DOT_DST_PREFIX)gitconfig:
	git config --global include.path $(DOT_DST_PREFIX)gitconfig.shared

# link to system wallpapers
$(DOT_DST_PREFIX)local/share/backgrounds/sys:
	mkdir -p 
	ln -s /usr/share/backgrounds $(DOT_DST_PREFIX)local/share/backgrounds/sys

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
