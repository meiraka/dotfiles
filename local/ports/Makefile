IGNORE = Makefile
APPS = $(filter-out $(IGNORE), $(wildcard *))

.PHONY: help list install update $(APPS)
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

list: version all ## show apps list

install: ## [app name] install specified apps
	@echo -n
	$(eval SUBTARGET := install)

update: ## [app name] update specified apps version
	@echo -n
	$(eval SUBTARGET := update)

version: ## [app name] show install app version
	@echo -n
	$(eval SUBTARGET := version)

versions: ## [app name] show all versions
	@echo -n
	$(eval SUBTARGET := versions)

all: $(APPS) ## install all apps

$(APPS): 
	@echo -n "$@	"
	@$(MAKE) --no-print-directory -C $@ $(SUBTARGET)
