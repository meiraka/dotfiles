INSTALL_DIR=$(INSTALL_PREFIX)/.local/opt

.PHONY: install update
install: $(HOME)/.cargo/bin/rustup $(HOME)/.cargo/bin/rls

VERSION=
INSTALLER=sh.rustup.rs

$(INSTALLER):
	curl -Lf https://$(INSTALLER) -o $(INSTALLER)

$(HOME)/.cargo/bin/rustup: $(INSTALLER)
	sh $(INSTALLER) -y --no-modify-path

$(HOME)/.cargo/bin/rls: $(HOME)/.cargo/bin/rustup
	rustup component add rls rust-analysis rust-src

.PHONY: update version versions installed
update:
	rustup update
version:
	@echo none
versions:
	@echo none
installed:
	@if [ -f "$(HOME)/.cargo/bin/rustup" ]; then echo none; else echo; fi
