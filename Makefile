# packages are located in the same directory as this makefile
STOW_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
# the target directory for the dotfiles is always the users home directory
TARGET   := $(HOME)
STOW     := stow --dir=$(STOW_DIR) --target=$(TARGET)

# discover packages in the stow directory
PACKAGES := $(shell find $(STOW_DIR) -mindepth 1 -maxdepth 1 -type d ! -name '.*' -printf '%f\n' | sort)
LINUX_PACKAGES := zsh git
MACOS_PACKAGES := zsh zsh-macos git

.PHONY: all clean help install-all uninstall-all list

all: install-all

clean: uninstall-all

install-all:
	@for pkg in $(PACKAGES); do \
		make install-$$pkg || exit 1; \
	done

uninstall-all:
	@for pkg in $(PACKAGES); do \
		make uninstall-$$pkg || exit 1; \
	done

install-linux:
	@for pkg in $(LINUX_PACKAGES); do \
  		make install-$$pkg || exit 1; \
  	done

uninstall-linux:
	@for pkg in $(LINUX_PACKAGES); do \
  		make uninstall-$$pkg || exit 1; \
  	done

install-macos:
	@for pkg in $(MACOS_PACKAGES); do \
  		make install-$$pkg || exit 1; \
  	done

uninstall-macos:
	@for pkg in $(MACOS_PACKAGES); do \
  		make uninstall-$$pkg || exit 1; \
  	done

install-%:
	@echo "Installing $* into $(TARGET)..."
	@# first we remove all existing files that would prevent us from stowing
	@find $(STOW_DIR)$* -type f | while read src; do \
		dest=$(TARGET)/$${src#$(STOW_DIR)$*/}; \
		if [ -f "$$dest" ] && [ ! -L "$$dest" ]; then \
			echo "removing $$dest"; \
			rm "$$dest"; \
		fi \
	done
	@echo "stowing"
	@# we use restow in case we use this after an update
	$(STOW) --restow $*
	@echo "Done."

uninstall-%:
	@echo "Uninstalling $* from $(TARGET)..."
	$(STOW) --delete $*
	@echo "Done."

list:
	@echo "Packages in $(STOW_DIR):"
	@for pkg in $(PACKAGES); do echo "  $$pkg"; done

help:
	@echo "Manages dotfiles using stow."
	@echo "Can install, update or delete all packages contained in this directory."
	@echo "To see a list of available packages use 'make list'"
