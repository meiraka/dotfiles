.PHONY: clean install
all:: install

INSTALL_PREFIX?=$(HOME)/.local

USER=neovim
REPO=neovim
VERSION=v0.8.3

ARCHIVE=$(VERSION).tar.gz
WORKDIR=$(REPO)-$(patsubst v%,%,$(VERSION))
BIN=$(WORKDIR)/build/bin/nvim
TARGET=$(INSTALL_PREFIX)/bin/nvim-$(VERSION)
TARGET_LINK=$(INSTALL_PREFIX)/bin/nvim
GITHUB_TAGS=https://api.github.com/repos/$(USER)/$(REPO)/tags
_:=$(shell if [ -d "$(TARGET)" ]; then touch "$(TARGET)"; fi)

$(ARCHIVE):
	curl -L https://github.com/$(USER)/$(REPO)/archive/refs/tags/$(ARCHIVE) -o $(ARCHIVE)

$(WORKDIR):| $(ARCHIVE)
	tar -xf $(ARCHIVE)

build: $(BIN)

$(BIN): $(WORKDIR)
	cd $(WORKDIR); make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)"

$(TARGET): $(BIN)
	cp $(BIN) $(TARGET)

$(TARGET_LINK): $(TARGET)
	@-rm $(TARGET_LINK)
	ln -si $(TARGET) $(TARGET_LINK)

install: $(TARGET_LINK)

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
