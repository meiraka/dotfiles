.PHONY: install
all: install

VERSION=v1.2.1
INSTALL_DIR=$(HOME)/.local

OS=$(shell uname -s | tr A-Z a-z)
ARCH=amd64

BIN_VERSION=ghq-$(VERSION)
BIN=ghq

TARGET=$(INSTALL_DIR)/bin/$(BIN_VERSION)
TARGET_LINK=$(INSTALL_DIR)/bin/$(BIN)
_:=$(shell if [ -d "$(TARGET)" ]; then touch "$(TARGET)"; fi)

ghq_$(OS)_$(ARCH)_$(VERSION).zip:
	mkdir -p $(INSTALL_DIR)/bin
	curl -L https://github.com/x-motemen/ghq/releases/download/$(VERSION)/ghq_$(OS)_$(ARCH).zip -o ghq_$(OS)_$(ARCH)_$(VERSION).zip

ghq_$(OS)_$(ARCH)_$(VERSION): ghq_$(OS)_$(ARCH)_$(VERSION).zip
	rm -rf ghq_$(OS)_$(ARCH)
	unzip ghq_$(OS)_$(ARCH)_$(VERSION).zip
	mv ghq_$(OS)_$(ARCH) ghq_$(OS)_$(ARCH)_$(VERSION)

$(TARGET): ghq_$(OS)_$(ARCH)_$(VERSION)
	cp ghq_$(OS)_$(ARCH)_$(VERSION)/$(BIN) $(INSTALL_DIR)/bin/$(BIN_VERSION)
	chmod +x $(INSTALL_DIR)/bin/$(BIN_VERSION)

$(TARGET_LINK): $(TARGET)
	ln -nsf $(TARGET) $(TARGET_LINK)

install: $(INSTALL_DIR)/bin/$(BIN)

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
