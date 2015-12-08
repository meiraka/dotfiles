DST_PREFIX = $(shell echo  ~/.)
SRC = $(filter-out Makefile config bootstrap, $(wildcard *))
CONFIGSRC = $(wildcard config/*)
DOTPATH = $(patsubst %, $(DST_PREFIX)%, $(SRC) $(CONFIGSRC))

link: $(DOTPATH) nvim

.PHONY: clean nvim
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

nvim:
	ln -s ~/.vim ~/.config/nvim
	ln -s ~/.vimrc ~/.config/nvim/init.vim
