.PHONY: all install
USER=yuru7
REPO=PlemolJP
VERSION=v3.0.0
INSTALL_DIR = $(HOME)/.local

ARCHIVES=PlemolJP_NF_$(VERSION).zip PlemolJP_$(VERSION).zip
SRC=PlemolJP_$(VERSION)/PlemolJP-Regular.ttf PlemolJP_NF_$(VERSION)/PlemolJPConsoleNF-Regular.ttf
TARGET=$(INSTALL_DIR)/share/fonts/PlemolJP-Regular.ttf

all: install
install: $(TARGET)
$(TARGET): $(SRC)
	mkdir -p $(INSTALL_DIR)/share/fonts/
	cp PlemolJP_NF_$(VERSION)/*.ttf $(INSTALL_DIR)/share/fonts/
	cp PlemolJP_$(VERSION)/*.ttf $(INSTALL_DIR)/share/fonts/
	echo "$(VERSION)" > INSTALLED
	-fc-cache -vf

.PHONY: extract
extract: $(SRC)
$(SRC): $(ARCHIVES)
	unzip -o ${@D}.zip
	mv ${@D}/*/*.ttf ${@D}/
	touch ${@D}/*

###

.PHONY: fetch
fetch: $(ARCHIVES)
$(ARCHIVES):
	curl -L https://github.com/$(USER)/$(REPO)/releases/download/$(VERSION)/$@ -o $@

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
