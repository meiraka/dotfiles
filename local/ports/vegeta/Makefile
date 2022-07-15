.PHONY: install uninstall
all: install

VERSION=v12.8.4
INSTALL_DIR=$(HOME)/.local

USER=tsenart
REPO=vegeta
BIN=vegeta
BIN_VERSION=$(BIN)-$(VERSION)

OS=$(shell uname -s | tr A-Z a-z)
_ARCH=$(shell uname -m)
ifeq ($(_ARCH), x86_64)
ARCH=amd64
else
ARCH=386
endif
TARGET=$(INSTALL_DIR)/bin/$(BIN_VERSION)
TARGET_LINK=$(INSTALL_DIR)/bin/$(BIN)
RELEASE_FILE=$(BIN)_$(patsubst v%,%,$(VERSION))_$(OS)_$(ARCH).tar.gz

_:=$(shell if [ -d "$(TARGET)" ]; then touch "$(TARGET)"; fi)

$(RELEASE_FILE):
	curl -L https://github.com/$(USER)/$(REPO)/releases/download/$(VERSION)/$(RELEASE_FILE) -o $(RELEASE_FILE)

$(BIN_VERSION): $(RELEASE_FILE)
	@rm -f vegeta
	tar xf $(RELEASE_FILE)
	mv $(BIN) $(BIN_VERSION)

$(TARGET): $(BIN_VERSION)
	@mkdir -p $(INSTALL_DIR)/bin
	cp $(BIN_VERSION) $(TARGET)
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
