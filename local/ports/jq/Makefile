.PHONY: install
all: install

VERSION=jq-1.7.1
GITHUB=https://github.com/stedolan/jq
INSTALL_DIR=$(HOME)/.local

OS=$(shell uname -s | tr A-Z a-z)
ifeq ($(OS),darwin)
BIN_ORIG=jq-osx-amd64
else
_ARCH=$(shell uname -m)
BIN_ORIG=jq-linux64
endif

BIN_VERSION=$(VERSION)
BIN=jq

TARGET=$(INSTALL_DIR)/bin/$(BIN_VERSION)
TARGET_LINK=$(INSTALL_DIR)/bin/$(BIN)
_:=$(shell if [ -f "$(TARGET)" ]; then touch "$(TARGET)"; fi)

$(TARGET):
	mkdir -p $(dir $(TARGET))
	curl -L $(GITHUB)/releases/download/$(VERSION)/$(BIN_ORIG) -o $(TARGET)
	chmod +x $(TARGET)

$(TARGET_LINK): $(TARGET)
	ln -nsf $(TARGET) $(TARGET_LINK)

install: $(TARGET_LINK)

GITHUB_RELEASES = https://api.github.com/repos/stedolan/jq/releases

.PHONY: update
update:
	$(eval NEW_VERSION := $(shell curl -sL $(GITHUB_RELEASES) | jq -r .[0].tag_name))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) install

version:
	@echo $(VERSION)

versions:
	@curl -s $(GITHUB_RELEASES) | jq -r '.[].tag_name'

INSTALLED=$(notdir $(shell readlink $(TARGET_LINK)))
installed:
	@echo $(INSTALLED)
