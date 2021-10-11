.PHONY: install
all: install

INSTALL_DIR=$(HOME)/.local

BIN=minecraft-launcher

Minecraft.tar.gz:
	curl -L https://launcher.mojang.com/download/Minecraft.tar.gz -o Minecraft.tar.gz

minecraft-launcher/$(BIN):
	rm -rf minecraft-launcher
	tar -xf Minecraft.tar.gz 

$(INSTALL_DIR)/bin/$(BIN):
	cp minecraft-launcher/$(BIN) $(INSTALL_DIR)/bin/$(BIN)

install: $(INSTALL_DIR)/bin/$(BIN)

update:
