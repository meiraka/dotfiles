DST_PREFIX = $(shell echo  ~/.)
SRC = $(filter-out Makefile config bootstrap, $(wildcard *))
CONFIGSRC = $(wildcard config/*)
DOTPATH = $(patsubst %, $(DST_PREFIX)%, $(SRC) $(CONFIGSRC))

link: $(DOTPATH) nvim
echo:
	echo $(DST_PREFIX)

.PHONY: clean
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

$(DST_PREFIX)config/nvim/init.vim: $(DST_PREFIX)vimrc
	ln -s $(DST_PREFIX)vim $(DST_PREFIX)config/nvim
	ln -s $(DST_PREFIX)vimrc $(DST_PREFIX)config/nvim/init.vim

nvim: $(DST_PREFIX)config/nvim/init.vim
