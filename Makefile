.PHONY: build
build:
	dune build

.PHONY: check
check:
	dune build @check

.PHONY: release
release:
	dune build --profile=release

.PHONY: test
test:
	dune test
