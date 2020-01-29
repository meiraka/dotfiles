.PHONY: install
all: install

TAG=v1.4.1
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
	cp -f ./*/*.ttf ~/.fonts/
	-fc-cache -vf

install: ~/.fonts/HackGen-Regular.ttf
