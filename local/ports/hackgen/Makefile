.PHONY: install
all: install

VERSION=v2.5.2
TAG=$(VERSION)
GITHUB=https://github.com/yuru7/HackGen
ARCHIVE=HackGen_$(TAG).zip
WORKDIR=HackGen_$(TAG)
TARGET_DIR = $(HOME)/.local/share/fonts/

$(ARCHIVE):
	curl -L https://github.com/yuru7/HackGen/releases/download/$(TAG)/$(ARCHIVE) -o $(ARCHIVE)

$(WORKDIR)/HackGen-Regular.ttf: $(ARCHIVE)
	unzip $(ARCHIVE)
	touch $(WORKDIR)/*

$(TARGET_DIR)HackGen-Regular.ttf: $(WORKDIR)/HackGen-Regular.ttf
	mkdir -p $(TARGET_DIR)
	cp -p -f $(WORKDIR)/*.ttf $(TARGET_DIR)
	-fc-cache -vf

install: $(TARGET_DIR)HackGen-Regular.ttf

.PHONY: update
update:
	$(eval NEW_TAG := $(shell curl https://api.github.com/repos/yuru7/HackGen/releases/latest | jq -r .tag_name))
	@if [ "$(NEW_TAG)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/TAG=$(TAG)/TAG=$(NEW_TAG)/" Makefile
	$(MAKE) install
