SHELL=/bin/bash

.PHONY: help
help:
	@awk -F':.*##' '/^[-_a-zA-Z0-9]+:.*##/{printf"%-12s\t%s\n",$$1,$$2}' $(MAKEFILE_LIST) | sort

.PHONY: format
format: format-clj format-es format-scala format-sql ## Format codes.

.PHONY: format-clj
format-clj:
	cljstyle fix

.PHONY: format-es
format-es:
	ag -g '\.c?js$$' --hidden | xargs -t npx prettier -w
	ag -g '\.json$$' | xargs -t npx prettier -w
	ag -g '\.ts$$' | xargs -t npx prettier -w
	ag -g '\.yaml$$' | xargs -t npx prettier -w
	npx prettier -w README.md

.PHONY: format-scala
format-scala:
	sbt scalafixAll scalafmtAll

.PHONY: format-sql
format-sql:
	ag -g '\.sql$$' | xargs -I{} -P $(shell nproc) -t npx sql-formatter -l postgresql -o {} {}

.PHONY: lint
lint: lint-clj lint-es lint-scala ## Lint.

.PHONY: lint-clj
lint-clj:
	cljstyle find | xargs -t clj-kondo --parallel --lint || true

.PHONY: lint-es
lint-es:
	npx -w packages/main eslint

.PHONY: lint-scala
lint-scala:
	sbt scalafmtCheckAll 'scalafixAll --check'

.PHONY: reset
reset: ## Reset development environment.
	./scripts/reset.clj

.PHONY: test
test: test-es test-scala ## Test

.PHONY: test-es
test-es:
	npm test

.PHONY: test-scala
test-scala:
	sbt test
