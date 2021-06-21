.PHONY: install
all: install

TAG=v2.3.2
GITHUB=https://github.com/yuru7/HackGen
ARCHIVE=HackGen_$(TAG).zip
WORKDIR=HackGen_$(TAG)

$(ARCHIVE):
	curl -L https://github.com/yuru7/HackGen/releases/download/$(TAG)/$(ARCHIVE) -o $(ARCHIVE)

$(WORKDIR)/HackGen-Regular.ttf: $(ARCHIVE)
	unzip $(ARCHIVE)
	touch $(WORKDIR)/*

~/.fonts/HackGen-Regular.ttf: $(WORKDIR)/HackGen-Regular.ttf
	mkdir -p ~/.fonts
	cp -p -f $(WORKDIR)/*.ttf ~/.fonts/
	-fc-cache -vf

install: ~/.fonts/HackGen-Regular.ttf

.PHONY: update
update:
	$(eval NEW_TAG := $(shell curl https://api.github.com/repos/yuru7/HackGen/releases/latest | jq -r .tag_name))
	@if [ "$(NEW_TAG)" = "" ]; then echo failed to fetch tag; exit 1; fi
	@sed -i -e "s/TAG=$(TAG)/TAG=$(NEW_TAG)/" Makefile
	$(MAKE) install
