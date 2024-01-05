debian-base-update:
	#sudo apt update && sudo apt upgrade -y
	@echo "Update apt"

debian-base-dotfiles:
	@echo "Copy some debian-specific dotfiles"

DEPENDENCY_TARGETS += debian-base-update
DOTFILE_TARGETS += debian-base-dotfiles
.PHONY: debian-base-update
