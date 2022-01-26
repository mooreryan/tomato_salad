BROWSER = firefox
TEST_COV_D = /tmp/tomato_salad
NAME = tomato_salad

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

.PHONY: test_coverage
test_coverage:
	if [ -d $(TEST_COV_D) ]; then rm -r $(TEST_COV_D); fi
	mkdir -p $(TEST_COV_D)
	BISECT_FILE=$(TEST_COV_D)/$(NAME) dune runtest --no-print-directory \
	  --instrument-with bisect_ppx --force
	bisect-ppx-report html --coverage-path $(TEST_COV_D)
	bisect-ppx-report summary --coverage-path $(TEST_COV_D)

.PHONY: test_coverage_open
test_coverage_open: test_coverage
	$(BROWSER) _coverage/index.html
