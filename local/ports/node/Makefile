.PHONY: clean install
install: link

VERSION=v24.16.0
INSTALL_PREFIX?=$(HOME)
INSTALL_DIR=$(INSTALL_PREFIX)/.local/opt

OS=$(shell uname -s | tr A-Z a-z)
ifeq ($(OS), darwin)
ENC=gz
else
ENC=xz
endif

ARCH=$(subst x86_64,x64,$(shell uname -m))

# https://nodejs.org/dist/v12.14.1/node-v12.14.1-linux-armv7l.tar.xz
# https://nodejs.org/dist/v12.14.1/node-v12.14.1-darwin-x64.tar.gz
# https://nodejs.org/dist/v12.14.1/node-v12.14.1-linux-x64.tar.xz



ARCHIVE=node-$(VERSION)-$(OS)-$(ARCH).tar.$(ENC)
TARGET=$(INSTALL_DIR)/node-$(VERSION)-$(OS)
TARGET_LINK=$(INSTALL_DIR)/node
_:=$(shell if [ -d "$(TARGET)" ]; then touch "$(TARGET)"; fi)

$(TARGET):
	curl -L https://nodejs.org/dist/$(VERSION)/$(ARCHIVE) -o $(ARCHIVE)
	tar -xf $(ARCHIVE)
	mkdir -p $(INSTALL_DIR)
	mv node-$(VERSION)-$(OS)-$(ARCH) $(TARGET)

clean:
	rm $(ARCHIVE)

$(TARGET_LINK): $(TARGET)
	@touch $(TARGET_LINK)
	@rm $(TARGET_LINK)
	ln -si $(TARGET) $(TARGET_LINK)

link: $(TARGET_LINK)

GITHUB_RELEASES = https://api.github.com/repos/nodejs/node/releases

.PHONY: update version versions
update:
	$(eval NEW_VERSION := $(shell curl -sL $(GITHUB_RELEASES) | jq -r '[.[] | select(.name | contains("LTS"))][0].tag_name'))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) link

version:
	@echo $(VERSION)

versions:
	@curl -s $(GITHUB_RELEASES) | jq -r '[.[] | select(.name | contains("LTS"))][].tag_name'

INSTALLED=$(subst -$(OS),,$(subst node-,,$(notdir $(shell readlink $(TARGET_LINK)))))
installed:
	@echo $(INSTALLED)
