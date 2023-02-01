SHELL=/bin/bash

.PHONY: help
help:
	@awk -F':.*##' '/^[-_a-zA-Z0-9]+:.*##/{printf"%-12s\t%s\n",$$1,$$2}' $(MAKEFILE_LIST) | sort

.PHONY: format
format: format-clj format-sql ## Format codes.

.PHONY: format-clj
format-clj:
	cljstyle fix

.PHONY: format-sql
format-sql:
	ag -g sql | xargs -I{} -P $(shell nproc) -t npx sql-formatter -l postgresql -o {} {}

.PHONY: lint
lint: lint-clj ## Lint.

.PHONY: lint-clj
lint-clj:
	cljstyle find | xargs -t clj-kondo --parallel --lint || true

.PHONY: reset
reset: ## Reset development environment.
	./scripts/reset.clj
