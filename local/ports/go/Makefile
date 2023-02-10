.PHONY: clean install
all: install

VERSION=go1.20
INSTALL_PREFIX?=$(HOME)
INSTALL_DIR=$(INSTALL_PREFIX)/.local/opt

OS=$(shell uname -s | tr A-Z a-z)
ARCH=$(subst x86_64,amd64,$(shell uname -m))

TARGET=$(INSTALL_DIR)/$(VERSION)
TARGET_LINK=$(INSTALL_DIR)/go
_:=$(shell if [ -d "$(TARGET)" ]; then touch "$(TARGET)"; fi)

ARCHIVE=$(VERSION).$(OS)-$(ARCH).tar.gz

$(TARGET):
	curl -L https://storage.googleapis.com/golang/$(ARCHIVE) -o $(ARCHIVE)
	tar -xzf $(ARCHIVE)
	mkdir -p $(INSTALL_DIR)
	mv go $(TARGET)

clean:
	rm $(ARCHIVE)

$(TARGET_LINK): $(TARGET)
	@touch $(TARGET_LINK)
	@rm $(TARGET_LINK)
	ln -si $(TARGET) $(TARGET_LINK)

install: $(TARGET_LINK)

src:
	@git clone https://go.googlesource.com/go src

.PHONY: update version versions
update: src
	$(eval NEW_VERSION := $(shell cd src && git fetch && git tag | grep -E -e '^go[0-9]+\.[0-9]+\.[0-9]+$$' -e '^go[0-9]+\.[0-9]+$$' | sort --version-sort | tail -n 1))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) install

version:
	@echo $(VERSION)

versions: src
	@cd src && git tag
