.PHONY: clean install
all:: install

INSTALL_PREFIX?=$(HOME)/.local

USER=neovim
REPO=neovim
VERSION=v0.8.2

ARCHIVE=$(VERSION).tar.gz
WORKDIR=$(REPO)-$(patsubst v%,%,$(VERSION))
TARGET=$(WORKDIR)/build/bin/nvim
TARGET_COPY=$(INSTALL_PREFIX)/bin/nvim
GITHUB_TAGS=https://api.github.com/repos/$(USER)/$(REPO)/tags

$(ARCHIVE):
	curl -L https://github.com/$(USER)/$(REPO)/archive/refs/tags/$(ARCHIVE) -o $(ARCHIVE)

$(WORKDIR):| $(ARCHIVE)
	tar -xf $(ARCHIVE)

$(TARGET): $(WORKDIR)
	cd $(WORKDIR); make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)"

$(TARGET_COPY): $(TARGET)
	cd $(WORKDIR); make install

install: $(TARGET_COPY)

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

clean:
	rm -rf *.tar.gz
	rm -rf neovim-*
