DST_PREFIX = $(shell echo  ~/.)
SRC = $(filter-out Makefile config bootstrap, $(wildcard *))
CONFIGSRC = $(wildcard config/*)
DOTPATH = $(patsubst %, $(DST_PREFIX)%, $(SRC) $(CONFIGSRC))

link: $(DOTPATH)

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
