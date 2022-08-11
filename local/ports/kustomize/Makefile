.PHONY: install
all: install

TAG=kustomize/v4.5.6
VERSION=$(TAG:kustomize/%=%)
INSTALL_DIR=$(HOME)/.local

OS=$(shell uname -s | tr A-Z a-z)
_ARCH=$(shell uname -m)
ifeq ($(_ARCH), armv6l)
ARCH=armv6l
else ifeq ($(_ARCH), armv7l)
# ARMv6 is upwards compatible with ARMv7
ARCH=armv6l
else ifeq ($(_ARCH), arm64)
ARCH=arm64
else ifeq ($(_ARCH), x86_64)
ARCH=amd64
else
ARCH=386
endif

BIN_VERSION=kustomize-$(VERSION)
BIN=kustomize

TARGET=$(INSTALL_DIR)/bin/$(BIN_VERSION)
TARGET_LINK=$(INSTALL_DIR)/bin/$(BIN)
_:=$(shell if [ -d "$(TARGET)" ]; then touch "$(TARGET)"; fi)


ARCHIVE=kustomize_$(VERSION)_$(OS)_$(ARCH).tar.gz
$(ARCHIVE):
	curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F$(VERSION)/$(ARCHIVE) -o $(ARCHIVE)

$(TARGET): $(ARCHIVE)
	tar -xf $(ARCHIVE)
	mv $(BIN) $(TARGET)
	touch $(TARGET)

$(TARGET_LINK): $(TARGET)
	ln -nsf $(TARGET) $(TARGET_LINK)

install: $(TARGET_LINK)

GITHUB_RELEASES=https://api.github.com/repos/kubernetes-sigs/kustomize/releases

.PHONY: update version versions
update:
	$(eval NEW_TAG := $(shell curl -s $(GITHUB_RELEASES) | jq -r '[.[] | select(.tag_name | startswith("kustomize/"))][0].tag_name'))
	@if [ "$(NEW_TAG)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "sZTAG=$(TAG)ZTAG=$(NEW_TAG)Z" Makefile
	$(MAKE) install

version:
	@echo $(TAG)

versions:
	@curl -s $(GITHUB_RELEASES) | jq -r '[.[] | select(.tag_name | startswith("kustomize/"))][].tag_name'
