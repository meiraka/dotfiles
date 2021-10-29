.PHONY: install
all: install

VERSION=
INSTALL_DIR=$(HOME)/.local

BIN=minecraft-launcher

Minecraft.tar.gz:
	curl -L https://launcher.mojang.com/download/Minecraft.tar.gz -o Minecraft.tar.gz

minecraft-launcher/$(BIN): Minecraft.tar.gz
	rm -rf minecraft-launcher
	tar -xf Minecraft.tar.gz 

$(INSTALL_DIR)/bin/$(BIN): minecraft-launcher/$(BIN)
	cp minecraft-launcher/$(BIN) $(INSTALL_DIR)/bin/$(BIN)

install: $(INSTALL_DIR)/bin/$(BIN)

.PHONY: update version versions
update:
version:
versions:
