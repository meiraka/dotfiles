INSTALL_DIR=$(INSTALL_PREFIX)/.local/opt

.PHONY: install update
install: $(HOME)/.cargo/bin/rustc

INSTALLER=sh.rustup.rs

$(INSTALLER):
	curl -Lf https://$(INSTALLER) -o $(INSTALLER)

$(HOME)/.cargo/bin/rustc: $(INSTALLER)
	sh $(INSTALLER) -y --no-modify-path

update:
	rm sh.rustup.rs
	$(MAKE) install


