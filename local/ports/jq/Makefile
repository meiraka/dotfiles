.PHONY: install
all: install

VERSION=jq-1.6
GITHUB=https://github.com/stedolan/jq
INSTALL_DIR=$(HOME)/.local

OS=$(shell uname -s | tr A-Z a-z)
ifeq ($(OS),darwin)
BIN_ORIG=jq-osx-amd64
else
_ARCH=$(shell uname -m)
ifeq ($(_ARCH), x86_64)
BIN_ORIG=jq-linux64
else
BIN_ORIG=jq-linux32
endif
endif

BIN_VERSION=$(VERSION)
BIN=jq
_:=$(shell if [ -e "$(INSTALL_DIR)/bin/$(BIN_VERSION)" ]; then touch "$(INSTALL_DIR)/bin/$(BIN_VERSION)"; fi)

$(INSTALL_DIR)/bin/$(BIN_VERSION):
	mkdir -p $(INSTALL_DIR)/bin
	curl -L $(GITHUB)/releases/download/$(VERSION)/$(BIN_ORIG) -o $(INSTALL_DIR)/bin/$(BIN_VERSION)
	chmod +x $(INSTALL_DIR)/bin/$(BIN_VERSION)

$(INSTALL_DIR)/bin/$(BIN): $(INSTALL_DIR)/bin/$(BIN_VERSION)
	ln -nsf $(INSTALL_DIR)/bin/$(BIN_VERSION) $(INSTALL_DIR)/bin/$(BIN)

install: $(INSTALL_DIR)/bin/$(BIN)

GITHUB_RELEASES = https://api.github.com/repos/stedolan/jq/releases

.PHONY: update
update:
	$(eval NEW_VERSION := $(shell curl -s $(GITHUB_RELEASES) | jq -r .[0].tag_name))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) install

version:
	@echo $(VERSION)

versions:
	@curl -s $(GITHUB_RELEASES) | jq -r '.[].tag_name'
