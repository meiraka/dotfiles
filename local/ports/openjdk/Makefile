.PHONY: install
all: install

INSTALL_DIR=$(HOME)/.local/opt

VERSION=
OS=$(shell uname -s | tr A-Z a-z)
ifeq ($(OS), darwin)
OS=osx
endif

_ARCH=$(shell uname -m)
ifeq ($(_ARCH), x86_64)
ARCH=x64
else
ARCH=aarch64
endif

JDK_VERSION=16.0.1
JDK_PATH=7147401fd7354114ac51ef3e1328291f/9
ARCHIVE=openjdk-$(JDK_VERSION)_$(OS)-$(ARCH)_bin.tar.gz
JDK_DIR=jdk-$(JDK_VERSION)

INSTALL_PATH=$(INSTALL_DIR)/jdk-$(JDK_VERSION)
INSTALL_LINK=$(INSTALL_DIR)/jdk

$(ARCHIVE):
	curl -L https://download.java.net/java/GA/jdk$(JDK_VERSION)/$(JDK_PATH)/GPL/$(ARCHIVE) -o $(ARCHIVE)

$(INSTALL_PATH): $(ARCHIVE)
	tar -xf $(ARCHIVE)
	@mkdir -p $(INSTALL_DIR)
	@touch $(INSTALL_PATH)
	@rm -rf $(INSTALL_PATH)
	mv jdk-$(JDK_VERSION) $(INSTALL_PATH)
	@touch $(INSTALL_PATH)

$(INSTALL_LINK): $(INSTALL_PATH)
	@touch $(INSTALL_LINK)
	@rm $(INSTALL_LINK)
	ln -si $(INSTALL_PATH) $(INSTALL_LINK)
		
install: $(INSTALL_LINK)

.PHONY: list
list:
	@echo $(sort $(dir $(wildcard $(INSTALL_DIR)/jdk-*/)))

.PHONY: update version versions
update:
version:
versions:
