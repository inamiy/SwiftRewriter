SHELL = /bin/bash

prefix ?= /usr/local
bindir ?= $(prefix)/bin
libdir ?= $(prefix)/lib
srcdir = Sources

REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build
SOURCES = $(wildcard $(srcdir)/**/*.swift)

.DEFAULT_GOAL = all

.PHONY: all
all: build

.PHONY: build
build: $(SOURCES)
	@swift build \
		-c release \
		--disable-sandbox \
		--build-path "$(BUILDDIR)"

.PHONY: install
install: build
	@install -d "$(bindir)" "$(libdir)"
	@install "$(BUILDDIR)/release/swift-rewriter" "$(bindir)"
	@install "$(BUILDDIR)/release/libSwiftSyntax.dylib" "$(libdir)"
	@install_name_tool -change \
		"$(BUILDDIR)/x86_64-apple-macosx10.10/release/libSwiftSyntax.dylib" \
		"$(libdir)/libSwiftSyntax.dylib" \
		"$(bindir)/swift-rewriter"

.PHONY: uninstall
uninstall:
	@rm -rf "$(bindir)/swift-rewriter"
	@rm -rf "$(libdir)/libSwiftSyntax.dylib"

.PHONY: bottle
bottle:
	brew tap inamiy/formulae/swift-rewriter
	brew install swift-rewriter --verbose --build-bottle
	brew bottle swift-rewriter
