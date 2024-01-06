help:
	@echo "Valid targets:"
	@echo "\tcommon\t\tCommon dotfiles and dependencies"
	@echo "\tdotfiles\tOnly copy dotfiles"
	@echo "\thome\t\tInstall home group packages"
	@echo "\tserver\t\tInstall server group packages"

ifeq ($(OS),Windows_NT)
currOs := win
else
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
currOs := linux
# The distribution should be able to be portably extracted by using
# /etc/os-release
# Note that there are more steps than just parsing this file on certain
# distributions. See
# https://gist.github.com/natefoo/814c5bf936922dad97ff
# for more details and alternatives
currDist := $(shell cat /etc/os-release | sed -n 's/^ID=\(.*\)$$/\1/p')
endif
ifeq ($(UNAME_S),Darwin)
currOs := macos
endif
endif

host := $(shell hostname)

$(info -- Running on host $(host))
$(info -- Detected OS $(currOs))
$(info -- Detected distribution $(currDist))
DEPENDENCY_TARGETS =
DOTFILE_TARGETS =
SOFTWARE_TARGETS =
CLEANUP_TARGETS =

# Group vars
HOME_TARGETS =
SERVER_TARGETS =

# First, check the OS
ifeq ($(currOs),linux)
$(info -- Linux identified)
# On Linux, we pay more attention to the distro than the OS
# Note that this is, strictly speaking, an implementation detail
ifeq ($(currDist),mint)
$(info -- Loading Mint-specific stuff)
include make/distros/mint.mk
endif # mint

ifeq ($(currDist),ubuntu)
$(info -- Loading ubuntu-specific stuff)
include make/distros/ubuntu.mk
endif # ubuntu

endif # linux

ifeq ($(currOs),win)
# Windows; no file has been included for this demo
endif
ifeq ($(currOs),macos)
# Mac; no file has been included for this demo
endif

# Host-specific include
-include make/host/$(host).mk

$(info $(DOTFILE_TARGETS))

common-dotfiles:
	@echo "Install some common dotfiles"

dependencies: $(DEPENDENCY_TARGETS);
dotfiles: common-dotfiles $(DOTFILE_TARGETS);
software: $(SOFTWARE_TARGETS);
cleanup: $(CLEANUP_TARGETS);

# Common setup process
core: dependencies dotfiles software
common: core cleanup

home: core $(HOME_TARGETS) cleanup
server: core $(SERVER_TARGETS) cleanup

# Makefile meta variables
.PHONY: common core dotfiles dependencies cleanup software
