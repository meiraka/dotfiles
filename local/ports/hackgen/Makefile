.PHONY: all install
USER=yuru7
REPO=HackGen
VERSION=v2.10.0
INSTALL_DIR = $(HOME)/.local

ARCHIVE=HackGen_NF_$(VERSION).zip
OLD=$(filter-out $(ARCHIVE),$(wildcard $(subst $(VERSION),*,$(ARCHIVE))))

FONTS=HackGen35ConsoleNF-Bold.ttf HackGen35ConsoleNF-Regular.ttf HackGenConsoleNF-Bold.ttf HackGenConsoleNF-Regular.ttf

TARGETS=$(addprefix $(INSTALL_DIR)/share/fonts/,$(FONTS))

all: install
install: $(TARGETS)
$(INSTALL_DIR)/share/fonts/:
	mkdir -p $(INSTALL_DIR)/share/fonts/

$(TARGETS): $(ARCHIVE) $(INSTALL_DIR)/share/fonts/
	unzip -p $(<) *$(@F) > $(@)
	@touch $(@)
	@echo "$(VERSION)" > INSTALLED

.PHONY: fetch
fetch: $(ARCHIVE)
$(ARCHIVE):
	curl -L https://github.com/$(USER)/$(REPO)/releases/download/$(VERSION)/$@ -o $@

list: $(ARCHIVE)
	@echo $(notdir $(filter %.ttf,$(shell unzip -Z1 $(ARCHIVE))))

clean:
	rm $(TARGETS)

GITHUB_RELEASES=https://api.github.com/repos/$(USER)/$(REPO)/releases

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

.PHONY: installed
installed:
	@cat INSTALLED 2> /dev/null || echo
