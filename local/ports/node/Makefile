.PHONY: clean link
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


VERSION=v12.14.1

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

link: $(INSTALL_PATH)
	@touch $(INSTALL_LINK)
	@rm $(INSTALL_LINK)
	ln -si $(INSTALL_PATH) $(INSTALL_LINK)
