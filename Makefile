# Makefile for Assignment 1
CC=gcc
CFLAGS=-O2 -Wall -Werror -Wno-unused-result -std=c99
LDFLAGS=-lm

GENERATOR_SOURCE = generator.py

SEARCHER_SOURCE=searcher.c
SEARCHER_BINARY=searcher

# non dependency commands for this Makefile
.PHONY: build
.PHONY: searcher
.PHONY: sample
.PHONY: test
.PHONY: clean

# default rule
build: searcher
	@echo "Build complete" 

searcher:
	@echo "Compiling Searcher..."
	${CC} ${CFLAGS} ${SEARCHER_SOURCE} -o ${SEARCHER_BINARY} ${LDFLAGS}
	@echo "Searcher compiled successfully."

sample:
	@if [ ! -f ${SEARCHER_BINARY} ]; then \
		{ \
			echo "Compiling Searcher..."; \
			${CC} ${CFLAGS} ${SEARCHER_SOURCE} -o ${SEARCHER_BINARY} ${LDFLAGS}; \
			echo "Searcher compiled successfully."; \
		} \
	fi
	@echo "Executing programs with a sample arguments...."
	@python3 ${GENERATOR_SOURCE} -N=20 -mindist=2 -rseed=3 | ./${SEARCHER_BINARY}
	@echo "Sample arguments executed successfully."

test:
	@if [ ! -f ${SEARCHER_BINARY} ]; then \
		{ \
			echo "Compiling Searcher..."; \
			${CC} ${CFLAGS} ${SEARCHER_SOURCE} -o ${SEARCHER_BINARY} ${LDFLAGS}; \
			echo "Searcher compiled successfully."; \
		} \
	fi
	@echo "Testing the program..."
	@chmod u+x ./tests/test.sh
	@./tests/test.sh
	@echo "All tests passed."

clean:
	@echo "Deleting all unnecessary files..."
	rm -f ${SEARCHER_BINARY}
	@echo "All unnecessary files deleted."

