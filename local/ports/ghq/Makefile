.PHONY: install
all: install

VERSION=v1.6.2
INSTALL_DIR=$(HOME)/.local

OS=$(shell uname -s | tr A-Z a-z)
ARCH=$(subst x86_64,amd64,$(shell uname -m))

BIN_VERSION=ghq-$(VERSION)
BIN=ghq

TARGET=$(INSTALL_DIR)/bin/$(BIN_VERSION)
TARGET_LINK=$(INSTALL_DIR)/bin/$(BIN)
_:=$(shell if [ -f "$(TARGET)" ]; then touch "$(TARGET)"; fi)

ARCHIVE=ghq_$(OS)_$(ARCH)_$(VERSION).zip

$(TARGET):
	curl -L https://github.com/x-motemen/ghq/releases/download/$(VERSION)/ghq_$(OS)_$(ARCH).zip -o $(ARCHIVE)
	mkdir -p $(INSTALL_DIR)/bin
	unzip -p $(ARCHIVE) ghq_$(OS)_$(ARCH)/$(BIN) > $(TARGET)
	chmod +x $(TARGET)

$(TARGET_LINK): $(TARGET)
	ln -nsf $(TARGET) $(TARGET_LINK)

install: $(TARGET_LINK)

GITHUB_RELEASES=https://api.github.com/repos/x-motemen/ghq/releases

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

INSTALLED=$(subst ghq-,,$(notdir $(shell readlink $(TARGET_LINK))))
installed:
	@echo $(INSTALLED)
