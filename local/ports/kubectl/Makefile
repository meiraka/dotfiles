.PHONY: install
all: install

VERSION=v1.24.2
INSTALL_DIR=$(HOME)/.local

OS=$(shell uname -s | tr A-Z a-z)
_ARCH=$(shell uname -m)
ifeq ($(_ARCH), armv6l)
ARCH=armv6l
else ifeq ($(_ARCH), armv7l)
# ARMv6 is upwards compatible with ARMv7
ARCH=armv6l
else ifeq ($(_ARCH), x86_64)
ARCH=amd64
else
ARCH=386
endif

BIN_VERSION=kubectl-$(VERSION)
BIN=kubectl

TARGET=$(INSTALL_DIR)/bin/$(BIN_VERSION)
TARGET_LINK=$(INSTALL_DIR)/bin/$(BIN)
_:=$(shell if [ -d "$(TARGET)" ]; then touch "$(TARGET)"; fi)

$(TARGET):
	mkdir -p $(INSTALL_DIR)/bin
	curl -L https://storage.googleapis.com/kubernetes-release/release/$(VERSION)/bin/$(OS)/$(ARCH)/$(BIN) -o $(TARGET)
	chmod +x $(TARGET)

$(TARGET_LINK): $(TARGET)
	ln -nsf $(TARGET) $(TARGET_LINK)

install: $(TARGET_LINK)

.PHONY: update version versions
update:
	$(eval NEW_VERSION := $(shell curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) install

version:
	@echo $(VERSION)

versions:
	@echo $(VERSION)
