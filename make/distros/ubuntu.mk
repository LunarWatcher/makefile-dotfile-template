include make/distros/debian-base.mk

ubuntu-dotfiles:
	@echo "Install some ubuntu dotfiles"

ubuntu-home-packages:
	@echo "Install some ubuntu home packages"

HOME_TARGETS += ubuntu-home-packages
DOTFILE_TARGETS += ubuntu-dotfiles
