.PHONY: clean install
all: install

VERSION=20.30.11-ca-fx-jdk20.0.1
INSTALL_PREFIX?=$(HOME)
INSTALL_DIR=$(INSTALL_PREFIX)/.local/opt

OS=$(subst darwin,macosx,$(shell uname -s | tr A-Z a-z))
ARCH=$(subst arm64,aarch64,$(subst x86_64,x64,$(shell uname -m)))

TARGET=$(INSTALL_DIR)/openjdk-azul-zulu-$(VERSION)
TARGET_LINK=$(INSTALL_DIR)/jdk
_:=$(shell if [ -d "$(TARGET)" ]; then touch "$(TARGET)"; fi)

ARCHIVE=zulu$(VERSION)-$(OS)_$(ARCH).tar.gz
DIR=$(subst .tar.gz,,$(ARCHIVE))

$(TARGET):
	curl -L https://cdn.azul.com/zulu/bin/$(ARCHIVE) -o $(ARCHIVE)
	tar -xzf $(ARCHIVE)
	mkdir -p $(INSTALL_DIR)
	mv $(DIR) $(TARGET)

clean:
	rm $(ARCHIVE)

$(TARGET_LINK): $(TARGET)
	@touch $(TARGET_LINK)
	@rm $(TARGET_LINK)
	ln -si $(TARGET) $(TARGET_LINK)

install: $(TARGET_LINK)
.PHONY: update version versions
update:

version:
	@echo $(VERSION)

versions: src
	@cd src && git tag

INSTALLED=$(notdir $(shell readlink $(TARGET_LINK)))
installed:
	@echo $(subst openjdk-azul-zulu-,,$(INSTALLED))
