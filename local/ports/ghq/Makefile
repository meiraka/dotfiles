.PHONY: install
all: install

RELEASE=v1.1.5
INSTALL_DIR=$(HOME)/.local

OS=$(shell uname -s | tr A-Z a-z)
ARCH=amd64

BIN_VERSION=ghq-$(RELEASE)
BIN=ghq

ghq_$(OS)_$(ARCH)_$(RELEASE).zip:
	mkdir -p $(INSTALL_DIR)/bin
	curl -L https://github.com/x-motemen/ghq/releases/download/$(RELEASE)/ghq_$(OS)_$(ARCH).zip -o ghq_$(OS)_$(ARCH)_$(RELEASE).zip

ghq_$(OS)_$(ARCH)_$(RELEASE): ghq_$(OS)_$(ARCH)_$(RELEASE).zip
	rm -rf ghq_$(OS)_$(ARCH)
	unzip ghq_$(OS)_$(ARCH)_$(RELEASE).zip
	mv ghq_$(OS)_$(ARCH) ghq_$(OS)_$(ARCH)_$(RELEASE)

$(INSTALL_DIR)/bin/$(BIN_VERSION): ghq_$(OS)_$(ARCH)_$(RELEASE)
	cp ghq_$(OS)_$(ARCH)_$(RELEASE)/$(BIN) $(INSTALL_DIR)/bin/$(BIN_VERSION)
	chmod +x $(INSTALL_DIR)/bin/$(BIN_VERSION)

$(INSTALL_DIR)/bin/$(BIN): $(INSTALL_DIR)/bin/$(BIN_VERSION)
	ln -nsf $(INSTALL_DIR)/bin/$(BIN_VERSION) $(INSTALL_DIR)/bin/$(BIN)

install: $(INSTALL_DIR)/bin/$(BIN)

.PHONY: update
update:
	$(eval NEW_RELEASE := $(shell curl https://api.github.com/repos/x-motemen/ghq/releases/latest | jq -r .tag_name))
	@if [ "$(NEW_RELEASE)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/RELEASE=$(RELEASE)/RELEASE=$(NEW_RELEASE)/" Makefile
	$(MAKE) install
