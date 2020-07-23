.PHONY: clean
all: link

INSTALL_PREFIX?=$(HOME)

OS=$(shell uname -s | tr A-Z a-z)
ifeq ($(OS), darwin)
ENC=gz
else
ENC=xz
endif
_ARCH=$(shell uname -m)
ifeq ($(_ARCH), armv7l)
ARCH=armv7l
else ifeq ($(_ARCH), x86_64)
ARCH=x64
else
ARCH=x86
endif

# https://nodejs.org/dist/v12.14.1/node-v12.14.1-linux-armv7l.tar.xz
# https://nodejs.org/dist/v12.14.1/node-v12.14.1-darwin-x64.tar.gz
# https://nodejs.org/dist/v12.14.1/node-v12.14.1-linux-x64.tar.xz


VERSION=v14.6.0

ARCHIVE=node-$(VERSION)-$(OS)-$(ARCH).tar.$(ENC)
INSTALL_DIR=$(INSTALL_PREFIX)/.local/opt
INSTALL_PATH=$(INSTALL_DIR)/node-$(VERSION)-$(OS)
INSTALL_LINK=$(INSTALL_DIR)/node

$(ARCHIVE):
	curl -L https://nodejs.org/dist/$(VERSION)/$(ARCHIVE) -o $(ARCHIVE)

$(INSTALL_PATH):| $(ARCHIVE)
	tar -xf $(ARCHIVE)
	mkdir -p $(INSTALL_DIR)
	mv node-$(VERSION)-$(OS)-$(ARCH) $(INSTALL_PATH)

clean:
	rm $(ARCHIVE)

$(INSTALL_LINK): $(INSTALL_PATH)
	@touch $(INSTALL_LINK)
	@rm $(INSTALL_LINK)
	ln -si $(INSTALL_PATH) $(INSTALL_LINK)

link: $(INSTALL_LINK)

src:
	@git clone git@github.com:nodejs/node.git src

.PHONY: update
update: src
	$(eval NEW_VERSION := $(shell cd src && git fetch && git tag | grep -E ^v[0-9]+\.[0-9]+\.[0-9]+$ | sort --version-sort | tail -n 1))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) link
