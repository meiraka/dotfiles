.PHONY: clean install
all:: install

INSTALL_PREFIX?=$(HOME)/.local

USER=vim
REPO=vim
TAG=8.2.0140

CONFIGURE_ARGS+= --with-features=huge
CONFIGURE_ARGS+= --enable-fail-if-missing
CONFIGURE_ARGS+= --prefix=$(INSTALL_PREFIX)

CONFIG_LOG=$(WORKDIR)/src/auto/config.log
ARCHIVE=v$(TAG).tar.gz
WORKDIR=$(REPO)-$(TAG)

$(ARCHIVE):
	curl -L https://github.com/$(USER)/$(REPO)/archive/$(ARCHIVE) -o $(ARCHIVE)

$(WORKDIR):| $(ARCHIVE)
	tar -xf $(ARCHIVE)

$(CONFIG_LOG):| $(WORKDIR)
	cd $(WORKDIR); ./configure $(CONFIGURE_ARGS)

$(WORKDIR)/src/vim: $(CONFIG_LOG)
	cd $(WORKDIR); make

clean:
	rm -rf $(ARCHIVE)
	rm -rf $(WORKDIR)

$(INSTALL_PREFIX)/bin/vim: $(WORKDIR)/src/vim
	cd $(WORKDIR); make install

install: $(INSTALL_PREFIX)/bin/vim
