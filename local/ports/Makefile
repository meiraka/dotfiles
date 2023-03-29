IGNORE = Makefile
APPS = $(filter-out $(IGNORE), $(wildcard *))
ifneq ("","$(VERSION)")
OPT_VERSION="VERSION=$(VERSION)"
endif

.PHONY: help list install update clean $(APPS)
help:
	@echo commands:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = " ## "}; {cmd=sub(":[^#]+#?","",$$1)}; {printf "\033[36m%-40s\033[0m %s\n", $$cmd, $$2}'

list: i-list all ## show apps list

install: # [VERSION=version] PACKAGE... ## install specified apps
	@:
	$(eval SUBTARGET := install)

update: # PACKAGE... ## update specified apps version
	@:
	$(eval SUBTARGET := update)

version: # PACKAGE... ## show install app version
	@:
	$(eval SUBTARGET := version)

versions: # PACKAGE... ## show available versions
	@:
	$(eval SUBTARGET := versions)

installed: # PACKAGE... ## show install app version
	@:
	$(eval SUBTARGET := installed)

clean: # PACKAGE... ## cleanup build files
	@:
	$(eval SUBTARGET := clean)

i-list: # PACKAGE... ## show human readable app state
	@:
	$(eval SUBTARGET := i-list)

all: $(APPS) ## install all apps

$(APPS): 
	@:
	@if [ "$(SUBTARGET)" = "i-list" ]; then \
		CURRENT=""; \
		LATEST=""; \
		CURRENT=`$(MAKE) $(OPT_VERSION) --no-print-directory -C $@ installed 2> /dev/null`; \
		LATEST=`$(MAKE) $(OPT_VERSION) --no-print-directory -C $@ version`; \
		if [ "$${CURRENT}" = "$${LATEST}" ]; then \
		echo "$${CURRENT},$${LATEST}" | awk -F ',' '{printf "\033[36m%-20s\033[0m \033[32m%-20s\033[0m %-20s\n", "$@", $$1, $$2}'; \
		else \
		echo "$${CURRENT},$${LATEST}" | awk -F ',' '{printf "\033[36m%-20s\033[0m \033[31m%-20s\033[0m %-20s\n", "$@", $$1, $$2}'; \
		fi \
		else \
		$(MAKE) $(OPT_VERSION) --no-print-directory -C $@ $(SUBTARGET) 2> /dev/null; \
		fi
