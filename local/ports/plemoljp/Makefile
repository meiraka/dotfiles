.PHONY: all install
USER=yuru7
REPO=PlemolJP
VERSION=v3.0.0
INSTALL_DIR = $(HOME)/.local
ARCHIVE=PlemolJP_NF_$(VERSION).zip
OLD=$(filter-out $(ARCHIVE),$(wildcard $(subst $(VERSION),*,$(ARCHIVE))))

FONTS=PlemolJP35ConsoleNF-Bold.ttf PlemolJP35ConsoleNF-BoldItalic.ttf PlemolJP35ConsoleNF-ExtraLight.ttf PlemolJP35ConsoleNF-ExtraLightItalic.ttf PlemolJP35ConsoleNF-Italic.ttf PlemolJP35ConsoleNF-Light.ttf PlemolJP35ConsoleNF-LightItalic.ttf PlemolJP35ConsoleNF-Medium.ttf PlemolJP35ConsoleNF-MediumItalic.ttf PlemolJP35ConsoleNF-Regular.ttf PlemolJP35ConsoleNF-SemiBold.ttf PlemolJP35ConsoleNF-SemiBoldItalic.ttf PlemolJP35ConsoleNF-Text.ttf PlemolJP35ConsoleNF-TextItalic.ttf PlemolJP35ConsoleNF-Thin.ttf PlemolJP35ConsoleNF-ThinItalic.ttf PlemolJPConsoleNF-Bold.ttf PlemolJPConsoleNF-BoldItalic.ttf PlemolJPConsoleNF-ExtraLight.ttf PlemolJPConsoleNF-ExtraLightItalic.ttf PlemolJPConsoleNF-Italic.ttf PlemolJPConsoleNF-Light.ttf PlemolJPConsoleNF-LightItalic.ttf PlemolJPConsoleNF-Medium.ttf PlemolJPConsoleNF-MediumItalic.ttf PlemolJPConsoleNF-Regular.ttf PlemolJPConsoleNF-SemiBold.ttf PlemolJPConsoleNF-SemiBoldItalic.ttf PlemolJPConsoleNF-Text.ttf PlemolJPConsoleNF-TextItalic.ttf PlemolJPConsoleNF-Thin.ttf PlemolJPConsoleNF-ThinItalic.ttf

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
