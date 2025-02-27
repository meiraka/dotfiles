.PHONY: clean install
all:: install

INSTALL_PREFIX?=$(HOME)/.local

USER=vim
REPO=vim
VERSION=v9.1.0756

CONFIGURE_ARGS+= --with-features=huge
CONFIGURE_ARGS+= --enable-fail-if-missing
CONFIGURE_ARGS+= --prefix=$(INSTALL_PREFIX)

CONFIG_LOG=$(WORKDIR)/src/auto/config.log
ARCHIVE=$(VERSION).tar.gz
WORKDIR=$(REPO)-$(patsubst v%,%,$(VERSION))

TARGET=$(WORKDIR)/src/vim
TARGET_COPY=$(INSTALL_PREFIX)/bin/vim

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

$(TARGET): $(CONFIG_LOG)
	cd $(WORKDIR); make -j$(JOBS)

clean:
	rm -rf $(ARCHIVE)
	rm -rf $(WORKDIR)

$(TARGET_COPY): $(TARGET)
	cd $(WORKDIR); make install

install: $(TARGET_COPY)

GITHUB_TAGS=https://api.github.com/repos/$(USER)/$(REPO)/tags

.PHONY: update version versions
update:
	$(eval NEW_VERSION := $(shell curl -s $(GITHUB_TAGS) | jq -re .[0].name))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) install

version:
	@echo $(VERSION)

versions:
	@curl -s $(GITHUB_TAGS) | jq -r '.[].name'
