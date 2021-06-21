.PHONY: clean
all: link

INSTALL_PREFIX?=$(HOME)

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

VERSION=go1.16.5

ARCHIVE=$(VERSION).$(OS)-$(ARCH).tar.gz
INSTALL_DIR=$(INSTALL_PREFIX)/.local/opt
INSTALL_PATH=$(INSTALL_DIR)/$(VERSION)
INSTALL_LINK=$(INSTALL_DIR)/go

$(ARCHIVE):
	curl -L https://storage.googleapis.com/golang/$(ARCHIVE) -o $(ARCHIVE)

$(INSTALL_PATH):| $(ARCHIVE)
	tar -xzf $(ARCHIVE)
	mkdir -p $(INSTALL_DIR)
	mv go $(INSTALL_PATH)

clean:
	rm $(ARCHIVE)

$(INSTALL_LINK): $(INSTALL_PATH)
	@touch $(INSTALL_LINK)
	@rm $(INSTALL_LINK)
	ln -si $(INSTALL_PATH) $(INSTALL_LINK)

link: $(INSTALL_LINK)

src:
	@git clone https://go.googlesource.com/go src

.PHONY: update
update: src
	$(eval NEW_VERSION := $(shell cd src && git fetch && git tag | grep -E -e '^go[0-9]+\.[0-9]+\.[0-9]+$$' -e '^go[0-9]+\.[0-9]+$$' | sort --version-sort | tail -n 1))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) link
