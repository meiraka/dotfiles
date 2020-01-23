.PHONY: clean
all: install

INSTALL_PREFIX?=$(HOME)/.local

USER=tmux
REPO=tmux
TAG=3.0a

ARCHIVE=tmux-$(TAG).tar.gz
WORKDIR=$(REPO)-$(TAG)
CONFIGURE_ARGS+= CFLAGS="-I$(INSTALL_PREFIX)/include" LDFLAGS="-L$(INSTALL_PREFIX)/lib" --prefix=$(INSTALL_PREFIX)

ifeq ($(JOBS),)
JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
ifeq ($(JOBS),)
JOBS := 1
endif
endif

$(ARCHIVE):
	curl -L https://github.com/$(USER)/$(REPO)/releases/download/$(TAG)/$(ARCHIVE) -o $(ARCHIVE)

$(WORKDIR):| $(ARCHIVE)
	tar -xzf $(ARCHIVE)

clean:
	rm -rf $(WORKDIR)
	rm $(ARCHIVE)

fetch: $(ARCHIVE)
extract: $(WORKDIR)
build-dep: apt

$(INSTALL_PREFIX)/lib/libevent.so:
	$(MAKE) -C ../libevent

$(WORKDIR)/tmux: $(WORKDIR) $(INSTALL_PREFIX)/lib/libevent.so
	cd $(WORKDIR); ./configure $(CONFIGURE_ARGS)
	make -C $(WORKDIR) -j$(JOBS)
	touch $(WORKDIR)/tmux

$(INSTALL_PREFIX)/bin/tmux: $(WORKDIR)/tmux
	cd $(WORKDIR); make install

install: $(INSTALL_PREFIX)/bin/tmux
