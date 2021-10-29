.PHONY: install
all: install

VERSION=v2.5.2
GITHUB=https://github.com/yuru7/HackGen
ARCHIVE=HackGen_$(VERSION).zip
WORKDIR=HackGen_$(VERSION)
TARGET_DIR = $(HOME)/.local/share/fonts/
_:=$(shell if [ -d "$(WORKDIR)/HackGen-Regular.ttf" ]; then touch "$(WORKDIR)/HackGen-Regular.ttf"; fi)

$(ARCHIVE):
	curl -L https://github.com/yuru7/HackGen/releases/download/$(VERSION)/$(ARCHIVE) -o $(ARCHIVE)

$(WORKDIR)/HackGen-Regular.ttf: $(ARCHIVE)
	unzip $(ARCHIVE)
	touch $(WORKDIR)/*

$(TARGET_DIR)HackGen-Regular.ttf: $(WORKDIR)/HackGen-Regular.ttf
	mkdir -p $(TARGET_DIR)
	cp -p -f $(WORKDIR)/*.ttf $(TARGET_DIR)
	-fc-cache -vf

install: $(TARGET_DIR)HackGen-Regular.ttf

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
