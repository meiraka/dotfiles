all: install

INSTALL_PREFIX?=$(HOME)/.local

USER=libevent
REPO=libevent
VER=2.1.11

ARCHIVE=libevent-$(VER)-stable.tar.gz
WORKDIR=libevent-$(VER)-stable
CONFIGURE_ARGS+= CFLAGS="-I$(INSTALL_PREFIX)/include" LDFLAGS="-L$(INSTALL_PREFIX)/lib" --prefix=$(INSTALL_PREFIX)

ifeq ($(JOBS),)
JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
ifeq ($(JOBS),)
JOBS := 1
endif
endif

https://github.com/libevent/libevent/releases/download/release-2.1.11-stable/libevent-2.1.11-stable.tar.gz

$(ARCHIVE):
	curl -L https://github.com/$(USER)/$(REPO)/releases/download/release-$(VER)-stable/$(ARCHIVE) -o $(ARCHIVE)

$(WORKDIR):| $(ARCHIVE)
	tar -xzf $(ARCHIVE)

clean:
	rm -rf $(WORKDIR)
	rm $(ARCHIVE)

fetch: $(ARCHIVE)
extract: $(WORKDIR)

$(WORKDIR)/libevent.la: $(WORKDIR)
	cd $(WORKDIR); ./configure $(CONFIGURE_ARGS)
	make -C $(WORKDIR) -j$(JOBS)

$(INSTALL_PREFIX)/lib/libevent.la: $(WORKDIR)/libevent.la
	cd $(WORKDIR); make install

install: $(INSTALL_PREFIX)/lib/libevent.la
