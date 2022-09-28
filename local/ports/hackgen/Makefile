.PHONY: install
all: install

VERSION=v2.7.1
INSTALL_DIR = $(HOME)/.local

ARCHIVE=HackGen_$(VERSION).zip
TARGET=HackGen_$(VERSION)/HackGen-Regular.ttf
TARGET_COPY=$(INSTALL_DIR)/share/fonts/HackGen-Regular.ttf

_:=$(shell if [ -f "$(TARGET)" ] && ! cmp -s "$(TARGET)" "$(TARGET_COPY)"; then touch "$(TARGET)"; fi)

GITHUB=https://github.com/yuru7/HackGen

$(TARGET):
	curl -L https://github.com/yuru7/HackGen/releases/download/$(VERSION)/$(ARCHIVE) -o $(ARCHIVE)
	unzip $(ARCHIVE)
	touch $(dir $(TARGET))/*

$(TARGET_COPY): $(TARGET)
	mkdir -p $(dir $(TARGET_COPY))
	cp -p -f $(dir $(TARGET))/*.ttf $(dir $(TARGET_COPY))
	-fc-cache -vf

install: $(TARGET_COPY)

GITHUB_RELEASES=https://api.github.com/repos/yuru7/HackGen/releases

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
