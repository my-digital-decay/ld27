# ------------------------------------------------------------------------------
# ld27 Makefile

all: osx
.PHONY: all


#
# Mac OSX
#

premake-osx: premake/premake4.lua
	@echo "Generating makefiles for osx ..."
	@premake4 --file=premake/premake4.lua --gcc=osx --platform=x32 gmake
.PHONY: premake-osx

osx-debug:
	@${MAKE} premake-osx
	@${MAKE} -C build/gmake-osx ld27 config=debug32
	@${MAKE} ctags
.PHONY: osx-debug

osx-release:
	@${MAKE} premake-osx
	@${MAKE} -C build/gmake-osx ld27 config=release32
	@${MAKE} ctags
.PHONY: osx-release

osx: osx-debug osx-release
.PHONY: osx

run-osx:
	@./bin/osx/ld27
.PHONY: run-osx

run-osx-d:
	@./bin/osx/ld27-d
.PHONY: run-osx

clean-osx:
	@test -d build/gmake-osx && ${MAKE} -C build/gmake-osx clean; true
	@test -d out/osx && rm -r out/osx; true
.PHONY: clean-osx


#
# Linux
#

premake-linux: premake/premake4.lua
	@echo "Generating makefiles for linux ..."
	@premake4 --file=premake/premake4.lua --gcc=linux --platform=x32 gmake
.PHONY: premake-ios

linux-debug:
	@${MAKE} premake-linux
	@${MAKE} -C build/gmake-linux ld27 config=debug32
.PHONY: linux-debug

linux-release:
	@${MAKE} premake-linux
	@${MAKE} -C build/gmake-linux ld27 config=release32
.PHONY: linux-release

linux: linux-debug linux-release
.PHONY: linux

clean-linux:
	@test -d build/gmake-linux && ${MAKE} -C build/gmake-linux clean; true
	@test -d out/linux && rm -r out/linux; true
.PHONY: clean-linux


#
# Common targets
#

ifeq ("$(shell which ctags)x", "x")
CTAGS := 
else
CTAGS := ctags
endif

CTAGS_FLAGS	:=  -I "AKU_API" \
				*.cpp *.h \
				moai/src/moai-core/*.h \
				moai/src/moai-sim/*.h \
				moai/src/moai-util/*.h \
				moai/src/config/moai_config.h

ctags:
ifeq ($(CTAGS),)
	@echo "No valid ctags command found"
else
	@echo "Generating ld27 tag files ..."
	@cd src/ ; $(CTAGS) $(CTAGS_FLAGS) &> /dev/null
endif
.PHONY: ctags

clean:
	@test -d build/gmake-osx && ${MAKE} -C build/gmake-osx clean; true
	@test -d build/gmake-linux && ${MAKE} -C build/gmake-linux clean; true
	@test -d out && rm -r out/; true
.PHONY: clean

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "TARGETS:"
	@echo "   all (default)"
	@echo "   osx"
	@echo "   osx-debug"
	@echo "   osx-release"
	@echo "   linux"
	@echo "   linux-debug"
	@echo "   linux-release"
	@echo "   clean"
	@echo "   help"
.PHONY: help

