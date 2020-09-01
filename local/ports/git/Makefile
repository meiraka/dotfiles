.PHONY: clean install
all:: install

INSTALL_PREFIX?=$(HOME)/.local

USER=git
REPO=git
TAG=v2.28.0

CONFIGURE_ARGS+= --prefix=$(INSTALL_PREFIX)

ARCHIVE=$(TAG).tar.gz
WORKDIR=$(REPO)-$(patsubst v%,%,$(TAG))

ifeq ($(JOBS),)
JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
ifeq ($(JOBS),)
JOBS := 1
endif
endif

$(ARCHIVE):
	curl -L https://github.com/$(USER)/$(REPO)/archive/$(ARCHIVE) -o $(ARCHIVE)

$(INSTALL_PREFIX)/bin/git: $(ARCHIVE)
	tar -xf $(ARCHIVE)
	cd $(WORKDIR); make configure
	cd $(WORKDIR); ./configure $(CONFIGURE_ARGS)
	cd $(WORKDIR); make -j$(JOBS)
	cd $(WORKDIR); make install
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
	@sed -i -e "s/TAG=$(TAG)/TAG=$(NEW_VERSION)/" Makefile
	$(MAKE) install
