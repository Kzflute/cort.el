TOP       := $(dir $(lastword $(MAKEFILE_LIST)))

EMACS     ?= emacs

LOAD_PATH := -L $(TOP)
BATCH     := $(EMACS) -Q --batch $(LOAD_PATH)

ELS   := srt.el
ELCS  := $(ELS:.el=.elc)

all: git-hook build

git-hook:
# cp git hooks to .git/hooks
	cp -a git-hooks/* .git/hooks/

build: $(ELCS)

%.elc: %.el
	@printf "Compiling $<\n"
	-@$(BATCH) -f batch-byte-compile $<

test: build
# If byte compile for specific emacs,
# set EMACS such as `EMACS=26.1 make`.
	$(BATCH) -l srt-tests.el -f srt-run-tests

localtest:
# Clean all of .elc, compile .el, and run test.

	$(call ECHO_MAGENTA, "test by emacs-22.1")
	make clean
	EMACS=emacs-22.1 make test

	@echo "\n"
	$(call ECHO_MAGENTA, "test by emacs-24.5")
	make clean
	EMACS=emacs-24.5 make test

	@echo "\n"
	$(call ECHO_MAGENTA, "test by emacs-26.1")
	make clean
	EMACS=emacs-26.1 make test

	@echo "\n"
	$(call ECHO_CYAN, "localtest completed!!")
	@echo "\n"

clean:
	-find . -type f -name "*.elc" | xargs rm

include Makefunc.mk

