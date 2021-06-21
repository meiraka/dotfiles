.PHONY: clean
all: install

INSTALL_PREFIX?=$(HOME)/.local

USER=tmux
REPO=tmux
TAG=3.2a

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

$(WORKDIR)/tmux: $(WORKDIR)
	cd $(WORKDIR); ./configure $(CONFIGURE_ARGS)
	make -C $(WORKDIR) -j$(JOBS)
	touch $(WORKDIR)/tmux

$(INSTALL_PREFIX)/bin/tmux: $(WORKDIR)/tmux
	cd $(WORKDIR); make install

install: $(INSTALL_PREFIX)/bin/tmux

.PHONY: update
update:
	$(eval NEW_TAG := $(shell curl https://api.github.com/repos/$(USER)/$(REPO)/releases/latest | jq -r .tag_name))
	@if [ "$(NEW_TAG)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/TAG=$(TAG)/TAG=$(NEW_TAG)/" Makefile
	$(MAKE) install
