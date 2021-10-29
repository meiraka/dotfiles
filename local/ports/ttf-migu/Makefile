.PHONY: clean install all
all: install
URL=https://osdn.net/projects/mix-mplus-ipa/downloads/72511
VERSION=20200307
MIGU1M_DIR=migu-1m-$(VERSION)
MIGU1C_DIR=migu-1c-$(VERSION)
MIGU1P_DIR=migu-1p-$(VERSION)

MIGU1M = migu-1m-regular.ttf migu-1m-bold.ttf
MIGU1C = migu-1c-regular.ttf migu-1c-bold.ttf
MIGU1P = migu-1p-regular.ttf migu-1p-bold.ttf

DIR = $(MIGU1M_DIR) $(MIGU1P_DIR) $(MIGU1C_DIR)
ARCHIVE = $(addsuffix .zip, $(DIR))

$(ARCHIVE):
	curl -L $(URL)/$@ -o $@

$(addprefix $(MIGU1M_DIR)/, $(MIGU1M)): $(MIGU1M_DIR).zip
	unzip -o $(MIGU1M_DIR)
	touch $(MIGU1M_DIR)/*

$(addprefix $(MIGU1C_DIR)/, $(MIGU1C)): $(MIGU1C_DIR).zip
	unzip -o $(MIGU1C_DIR)
	touch $(MIGU1C_DIR)/*

$(addprefix $(MIGU1P_DIR)/, $(MIGU1P)): $(MIGU1P_DIR).zip
	unzip -o $(MIGU1P_DIR)
	touch $(MIGU1P_DIR)/*

TARGET_DIR = $(HOME)/.local/share/fonts/
TARGET=$(addprefix $(TARGET_DIR), $(MIGU1M) $(MIGU1C) $(MIGU1P))

$(addprefix $(TARGET_DIR), $(MIGU1M)): $(TARGET_DIR)%: $(MIGU1M_DIR)/%
	cp $< $@
$(addprefix $(TARGET_DIR), $(MIGU1C)): $(TARGET_DIR)%: $(MIGU1C_DIR)/%
	cp $< $@
$(addprefix $(TARGET_DIR), $(MIGU1P)): $(TARGET_DIR)%: $(MIGU1P_DIR)/%
	cp $< $@

clean:
	rm -rf $(ARCHIVE) $(DIR)

install: $(TARGET)
update:
