.PHONY: all install
USER=ryanoasis
REPO=nerd-fonts
VERSION=v3.2.1
INSTALL_DIR = $(HOME)/.local

ARCHIVES=NerdFontsSymbolsOnly-$(VERSION).zip
TARGET=$(INSTALL_DIR)/share/fonts/Symbols-1000-em\ Nerd\ Font\ Complete\ Mono.ttf

all: install
install: $(TARGET)
$(TARGET): $(ARCHIVES)
	unzip -o $(ARCHIVES) '*.ttf'
	cp *.ttf $(INSTALL_DIR)/share/fonts/
	echo "$(VERSION)" > INSTALLED
	-fc-cache -vf

.PHONY: fetch
fetch: $(ARCHIVES)
$(ARCHIVES):
	curl -L https://github.com/$(USER)/$(REPO)/releases/download/$(VERSION)/$(subst -$(VERSION),,$@) -o $@

GITHUB_RELEASES=https://api.github.com/repos/$(USER)/$(REPO)/releases

.PHONY: update version versions
update:
	$(eval NEW_VERSION := $(shell curl -sL $(GITHUB_RELEASES) | jq -r .[0].tag_name))
	@if [ "$(NEW_VERSION)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/VERSION=$(VERSION)/VERSION=$(NEW_VERSION)/" Makefile
	$(MAKE) install

version:
	@echo $(VERSION)

versions:
	@curl -s $(GITHUB_RELEASES) | jq -r '.[].tag_name'

.PHONY: installed
installed:
	@cat INSTALLED 2> /dev/null || echo
