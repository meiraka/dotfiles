.PHONY: install uninstall
all: install

VERSION=v4.43.1
INSTALL_DIR=$(HOME)/.local

USER=mikefarah
REPO=yq
BIN=yq
BIN_VERSION=$(BIN)-$(VERSION)

OS=$(shell uname -s | tr A-Z a-z)
ARCH=$(subst x86_64,amd64,$(shell uname -m))
TARGET=$(INSTALL_DIR)/bin/$(BIN_VERSION)
TARGET_LINK=$(INSTALL_DIR)/bin/$(BIN)
RELEASE_FILE=$(BIN)_$(OS)_$(ARCH)

_:=$(shell if [ -f "$(TARGET)" ]; then touch "$(TARGET)"; fi)

$(TARGET):
	@mkdir -p $(INSTALL_DIR)/bin
	curl -L https://github.com/$(USER)/$(REPO)/releases/download/$(VERSION)/$(RELEASE_FILE) -o $(TARGET)
	chmod +x $(TARGET)

$(TARGET_LINK): $(TARGET)
	ln -nsf $(TARGET) $(TARGET_LINK)

install: $(TARGET_LINK)

GITHUB_RELEASES=https://api.github.com/repos/$(USER)/$(REPO)/releases

.PHONY: update version versions
update:
	$(eval NEW_VERSION := $(shell curl -s $(GITHUB_RELEASES) | jq -r .[0].tag_name))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) install

version:
	@echo $(VERSION)

versions:
	@curl -s $(GITHUB_RELEASES) | jq -r '.[].tag_name'

uninstall:
	rm -f $(TARGET_LINK) $(TARGET)

INSTALLED=$(subst $(BIN)-,,$(notdir $(shell readlink $(TARGET_LINK))))
installed:
	@echo $(INSTALLED)
