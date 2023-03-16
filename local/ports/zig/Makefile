.PHONY: clean install
all: install

VERSION=0.10.1
INSTALL_PREFIX?=$(HOME)
INSTALL_DIR=$(INSTALL_PREFIX)/.local/opt

OS=$(subst darwin,macos,$(shell uname -s | tr A-Z a-z))
ARCH=$(subst arm64,aarch64,$(shell uname -m))

TARGET=$(INSTALL_DIR)/zig-$(VERSION)
TARGET_LINK=$(INSTALL_DIR)/zig
_:=$(shell if [ -d "$(TARGET)" ]; then touch "$(TARGET)"; fi)

ARCHIVE=zig-$(OS)-$(ARCH)-$(VERSION).tar.xz

$(TARGET):
	curl -L https://ziglang.org/download/$(VERSION)/$(ARCHIVE) -o $(ARCHIVE)
	tar -xf $(ARCHIVE)
	mkdir -p $(INSTALL_DIR)
	mv zig-$(OS)-$(ARCH)-$(VERSION) $(TARGET)
	rm $(ARCHIVE)

clean:

$(TARGET_LINK): $(TARGET)
	@touch $(TARGET_LINK)
	@rm $(TARGET_LINK)
	ln -si $(TARGET) $(TARGET_LINK)

install: $(TARGET_LINK)

USER=ziglang
REPO=zig
GITHUB_TAGS=https://api.github.com/repos/$(USER)/$(REPO)/tags

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

INSTALLED=$(subst zig-,,$(notdir $(shell readlink $(TARGET_LINK))))
installed:
	@echo $(INSTALLED)
