.PHONY: clean
all: install

INSTALL_PREFIX?=$(HOME)/.local

USER=tmux
REPO=tmux
VERSION=3.3a

ARCHIVE=tmux-$(VERSION).tar.gz
WORKDIR=$(REPO)-$(VERSION)
CONFIGURE_ARGS+= CFLAGS="-I$(INSTALL_PREFIX)/include" LDFLAGS="-L$(INSTALL_PREFIX)/lib" --prefix=$(INSTALL_PREFIX)

ifeq ($(JOBS),)
JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
ifeq ($(JOBS),)
JOBS := 1
endif
endif
_:=$(shell if [ -d "$(WORK_DIR)/tmux" ]; then touch "$(INSTALL_PATH)/tmux"; fi)

$(ARCHIVE):
	curl -L https://github.com/$(USER)/$(REPO)/releases/download/$(VERSION)/$(ARCHIVE) -o $(ARCHIVE)

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
	$(eval NEW_VERSION := $(shell curl https://api.github.com/repos/$(USER)/$(REPO)/releases/latest | jq -r .tag_name))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) install

version:
	@echo $(VERSION)

versions: src
	@cd src && git tag
