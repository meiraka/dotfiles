.PHONY: install
all: install

RELEASE=v1.17.3
INSTALL_DIR=$(HOME)/.local

OS=$(shell uname -s | tr A-Z a-z)
ARCH=amd64

BIN_VERSION=kubectl-$(RELEASE)
BIN=kubectl

$(INSTALL_DIR)/bin/$(BIN_VERSION):
	mkdir -p $(INSTALL_DIR)/bin
	curl -L https://storage.googleapis.com/kubernetes-release/release/$(RELEASE)/bin/$(OS)/$(ARCH)/$(BIN) -o $(INSTALL_DIR)/bin/$(BIN_VERSION)
	chmod +x $(INSTALL_DIR)/bin/$(BIN_VERSION)

$(INSTALL_DIR)/bin/$(BIN): $(INSTALL_DIR)/bin/$(BIN_VERSION)
	ln -nsf $(INSTALL_DIR)/bin/$(BIN_VERSION) $(INSTALL_DIR)/bin/$(BIN)

install: $(INSTALL_DIR)/bin/$(BIN)

.PHONY: update
update:
	$(eval NEW_RELEASE := $(shell curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt))
	@if [ "$(NEW_RELEASE)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/RELEASE=$(RELEASE)/RELEASE=$(NEW_RELEASE)/" Makefile
	$(MAKE) install
