SHELL=/bin/bash

.PHONY: help
help:
	@awk -F':.*##' '/^[-_a-zA-Z0-9]+:.*##/{printf"%-12s\t%s\n",$$1,$$2}' $(MAKEFILE_LIST) | sort

.PHONY: format
format: format-clj format-md format-scala format-sql ## Format codes.

.PHONY: format-clj
format-clj:
	cljstyle fix

.PHONY: format-md
format-md:
	npx prettier -w *.md

.PHONY: format-scala
format-scala:
	sbt scalafixAll scalafmtAll

.PHONY: format-sql
format-sql:
	ag -g sql | xargs -I{} -P $(shell nproc) -t npx sql-formatter -l postgresql -o {} {}

.PHONY: lint
lint: lint-clj lint-scala ## Lint.

.PHONY: lint-clj
lint-clj:
	cljstyle find | xargs -t clj-kondo --parallel --lint || true

.PHONY: lint-scala
lint-scala:
	sbt scalafmtCheckAll 'scalafixAll --check'

.PHONY: reset
reset: ## Reset development environment.
	./scripts/reset.clj

.PHONY: test
test: test-scala ## Test

.PHONY: test-scala
test-scala:
	sbt test
