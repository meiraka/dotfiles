IGNORE = Makefile
APPS = $(filter-out $(IGNORE), $(wildcard *))
ifneq ("","$(VERSION)")
OPT_VERSION="VERSION=$(VERSION)"
endif

.PHONY: help list install update clean $(APPS)
help:
	@echo commands:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = " ## "}; {cmd=sub(":[^#]+#?","",$$1)}; {printf "\033[36m%-40s\033[0m %s\n", $$cmd, $$2}'

list: version all ## show apps list

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

clean: # PACKAGE... ## cleanup build files
	@:
	$(eval SUBTARGET := clean)

all: $(APPS) ## install all apps

$(APPS): 
	@:
	@$(MAKE) $(OPT_VERSION) --no-print-directory -C $@ $(SUBTARGET) | awk '{printf "\033[36m%-20s\033[0m %s\n", "$@", $$0}'
