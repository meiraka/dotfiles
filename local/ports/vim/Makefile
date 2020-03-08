.PHONY: clean install
all:: install

INSTALL_PREFIX?=$(HOME)/.local

USER=vim
REPO=vim
TAG=v8.2.0363

CONFIGURE_ARGS+= --with-features=huge
CONFIGURE_ARGS+= --enable-fail-if-missing
CONFIGURE_ARGS+= --prefix=$(INSTALL_PREFIX)

CONFIG_LOG=$(WORKDIR)/src/auto/config.log
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

$(WORKDIR):| $(ARCHIVE)
	tar -xf $(ARCHIVE)

$(CONFIG_LOG):| $(WORKDIR)
	cd $(WORKDIR); ./configure $(CONFIGURE_ARGS)

$(WORKDIR)/src/vim: $(CONFIG_LOG)
	cd $(WORKDIR); make -j$(JOBS)

clean:
	rm -rf $(ARCHIVE)
	rm -rf $(WORKDIR)

$(INSTALL_PREFIX)/bin/vim: $(WORKDIR)/src/vim
	cd $(WORKDIR); make install

install: $(INSTALL_PREFIX)/bin/vim

.PHONY: update
update:
	$(eval NEW_TAG := $(shell curl https://api.github.com/repos/$(USER)/$(REPO)/tags | jq -re .[0].name))
	@if [ "$(NEW_TAG)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/TAG=$(TAG)/TAG=$(NEW_TAG)/" Makefile
	$(MAKE) install
