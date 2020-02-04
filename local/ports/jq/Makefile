.PHONY: install
all: install

TAG=jq-1.6
GITHUB=https://github.com/stedolan/jq
INSTALL_DIR=$(HOME)/.local

OS=$(shell uname -s | tr A-Z a-z)
ifeq ($(OS),darwin)
BIN_ORIG=jq-osx-amd64
endif
_ARCH=$(shell uname -m)
ifeq ($(_ARCH), x86_64)
BIN_ORIG=jq-linux64
else
BIN_ORIG=jq-linux32
endif

BIN_VERSION=jq-1.6
BIN=jq

$(INSTALL_DIR)/bin/$(BIN_VERSION):
	mkdir -p $(INSTALL_DIR)/bin
	curl -L $(GITHUB)/releases/download/$(TAG)/$(BIN_ORIG) -o $(INSTALL_DIR)/bin/$(BIN_VERSION)
	chmod +x $(INSTALL_DIR)/bin/$(BIN_VERSION)

$(INSTALL_DIR)/bin/$(BIN): $(INSTALL_DIR)/bin/$(BIN_VERSION)
	ln -nsf $(INSTALL_DIR)/bin/$(BIN_VERSION) $(INSTALL_DIR)/bin/$(BIN)

install: $(INSTALL_DIR)/bin/$(BIN)
