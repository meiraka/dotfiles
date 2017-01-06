DST_PREFIX = $(shell echo  ~/.)
IGNORE = Makefile config bootstrap
SRC = $(filter-out $(IGNORE), $(wildcard *))
CONFIGSRC = $(wildcard config/*)
DOTPATH = $(patsubst %, $(DST_PREFIX)%, $(SRC) $(CONFIGSRC))

all: link gitconfig
link: $(DOTPATH) $(DST_PREFIX)vimrc $(DST_PREFIX)vim $(DST_PREFIX)config

.PHONY: clean gitconfig
clean:
	@LIST="$(DOTPATH)";\
		for x in $$LIST; do\
		if [ ! -L "$$x" ]; then\
		echo warning: "$$x" is not symbolic link\
		; else\
		rm "$$x";\
		fi\
		done

$(DOTPATH): $(DST_PREFIX)%: %
	ln -s $(abspath $<) $@

$(DST_PREFIX)config:
	mkdir -p $(DST_PREFIX)config

$(DST_PREFIX)vimrc:
	ln -s $(DST_PREFIX)config/nvim/init.vim $(DST_PREFIX)vimrc

$(DST_PREFIX)vim:
	ln -s $(DST_PREFIX)config/nvim $(DST_PREFIX)vim

gitconfig:
	@touch $(DST_PREFIX)gitconfig
	@if ! grep .gitconfig.shared $(DST_PREFIX)gitconfig 2> /dev/null > /dev/null; then\
		echo "[include]" >> $(DST_PREFIX)gitconfig;\
		echo "    path = $(DST_PREFIX)gitconfig.shared" >> $(DST_PREFIX)gitconfig;\
		fi

