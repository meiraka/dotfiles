IGNORE = Makefile
APPS = $(filter-out $(IGNORE), $(wildcard *))

.PHONY: help list install update $(APPS)
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

list:  ## show apps list
	@LIST="$(APPS)";\
		for x in $$LIST; do\
		echo "$$x";\
		done

install: ## [app name] install specified apps
	$(eval SUBTARGET := install)

update: ## [app name] update specified apps version
	$(eval SUBTARGET := update)

all: $(APPS) ## install all apps

$(APPS): 
	$(MAKE) -C $@ $(SUBTARGET)
