# OS Specific
# set default shell to cmd.exe, fixing git-shell issues with gnu-make.
ifeq ($(OS), Windows_NT)
	SHELL = C:\Windows\SysWOW64\cmd.exe
endif

LS     = node_modules/LiveScript
LSC    = node_modules/".bin"/lsc
MOCHA  = node_modules/".bin"/mocha
MKDIRP = node_modules/".bin"/mkdirp

SRC  = $(shell find src -maxdepth 1 -name "*.ls" -type f | sort)
DIST = dist $(SRC:src/%.ls=dist/%.js)

build: $(DIST)

install:
	@npm install .

test: build
	@NODE_PATH="$(PWD)/test-fixtures" $(MOCHA) tests -u tdd -R spec -t 5000 --compilers ls:$(LS) -r "./test-runner.js" -c -S -b --recursive --check-leaks --inline-diffs

clean:
	@rm -rf dist
	@sleep .1 # wait for editor to refresh the file tree.......

.PHONY: build install test clean

%:
	@$(MKDIRP) $@

dist/%.js: src/%.ls
	$(LSC) --bare -o "$(shell dirname $@)" -c "$<"
