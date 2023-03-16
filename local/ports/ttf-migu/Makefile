.PHONY: clean install all
all: install
URL=https://osdn.net/projects/mix-mplus-ipa/downloads/72511
VERSION=20200307
MIGU_DIR=migu-$(VERSION)
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

$(addprefix $(MIGU_DIR)/, $(MIGU1M)): $(MIGU1M_DIR).zip
	unzip -o $(MIGU1M_DIR)
	mkdir -p $(MIGU_DIR)
	mv $(MIGU1M_DIR)/*.ttf $(MIGU_DIR)
	touch $(MIGU_DIR)/*

$(addprefix $(MIGU_DIR)/, $(MIGU1C)): $(MIGU1C_DIR).zip
	unzip -o $(MIGU1C_DIR)
	mkdir -p $(MIGU_DIR)
	mv $(MIGU1C_DIR)/*.ttf $(MIGU_DIR)
	touch $(MIGU_DIR)/*

$(addprefix $(MIGU_DIR)/, $(MIGU1P)): $(MIGU1P_DIR).zip
	unzip -o $(MIGU1P_DIR)
	mkdir -p $(MIGU_DIR)
	mv $(MIGU1P_DIR)/*.ttf $(MIGU_DIR)
	touch $(MIGU_DIR)/*

TARGET_DIR = $(HOME)/.local/share/fonts/
TARGET=$(addprefix $(TARGET_DIR), $(MIGU1M) $(MIGU1C) $(MIGU1P))

$(TARGET): $(addprefix $(MIGU_DIR)/, $(MIGU1M) $(MIGU1C) $(MIGU1P)) 
	mkdir -p $(TARGET_DIR)
	cp $(MIGU_DIR)/*.ttf $(TARGET_DIR)
	echo "$(VERSION)" > INSTALLED
	-fc-cache -vf

clean:
	rm -rf $(ARCHIVE) $(DIR)

install: $(TARGET)
update:
version:
	@echo $(VERSION)
versions:
	@echo $(VERSION)

.PHONY: installed
installed:
	@cat INSTALLED 2> /dev/null || echo
