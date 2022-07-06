.PHONY: clean install
all:: install

INSTALL_PREFIX?=$(HOME)/.local

USER=git
REPO=git
VERSION=v2.37.0

CONFIGURE_ARGS+= --prefix=$(INSTALL_PREFIX)

ARCHIVE=$(VERSION).tar.gz
WORKDIR=$(REPO)-$(patsubst v%,%,$(VERSION))

ifeq ($(JOBS),)
JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
ifeq ($(JOBS),)
JOBS := 1
endif
endif

_:=$(shell if [ -d "$(WORKDIR)/git" ]; then touch "$(WORKDIR)/git"; fi)

$(ARCHIVE):
	curl -L https://github.com/$(USER)/$(REPO)/archive/$(ARCHIVE) -o $(ARCHIVE)

$(WORKDIR): $(ARCHIVE)
	tar -xf $(ARCHIVE)
	touch $(WORKDIR)

$(WORKDIR)/git: $(WORKDIR)
	cd $(WORKDIR); make configure
	cd $(WORKDIR); ./configure $(CONFIGURE_ARGS)
	cd $(WORKDIR); make -j$(JOBS)
	touch $(WORKDIR)/git

$(INSTALL_PREFIX)/bin/git: $(WORKDIR)/git
	cd $(WORKDIR); make install
	touch $(WORKDIR)/git
	touch $(INSTALL_PREFIX)/bin/git

clean:
	rm -rf $(ARCHIVE)
	rm -rf $(WORKDIR)

install: $(INSTALL_PREFIX)/bin/git

src:
	@git clone https://github.com/git/git.git src

.PHONY: update
update: src
	$(eval NEW_VERSION := $(shell cd src && git fetch && git tag | grep -E -e '^v[0-9]+\.[0-9]+\.[0-9]+$$' | sort --version-sort | tail -n 1))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) install

version:
	@echo $(VERSION)

versions: src
	@cd src && git tag
