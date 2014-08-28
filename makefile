ifeq ($(OS), Windows_NT)
	# set default shell to cmd.exe (git-shell workaround)
	SHELL = C:\Windows\SysWOW64\cmd.exe
endif

# bin
LS         = node_modules/LiveScript
LSC        = node_modules/".bin"/lsc
MOCHA      = node_modules/".bin"/mocha
MOCHAPARAM = -u tdd -R list -t 2000 -r test-adapter.js --compilers ls:$(LS) -c -S -b --recursive --check-leaks --inline-diffs

# glob source
GLOB_SOURCE = $(shell find source -name "*.ls" -type f | sort)
SOURCE      = $(GLOB_SOURCE:source/%.ls=build/%.js)

# commands
default: build

build: $(SOURCE)

test: build
	@$(MOCHA) test/spec $(MOCHAPARAM)

clean:
	rm -rf build

.PHONY: default build test clean

# targets
build/%.js: source/%.ls
	MKDIR build
	$(LSC) --bare -o "$(shell dirname $@)" -c "$<"

