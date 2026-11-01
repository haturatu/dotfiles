REPO_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
CURRENT_SHELL := $(notdir $(shell printf '%s' "$$SHELL"))
DOTFILES_SCRIPT := $(REPO_ROOT)/scripts/dotfiles.sh
VIM_PLUGIN_SCRIPT := $(REPO_ROOT)/scripts/vim-plugins.sh

all: install

install:
ifeq ($(CURRENT_SHELL),bash)
	@sh "$(DOTFILES_SCRIPT)" install vim bash
else
	@sh "$(DOTFILES_SCRIPT)" install vim
	@echo "Current shell is not bash (found: $(CURRENT_SHELL)), skipping bash installation"
endif
	@sh "$(VIM_PLUGIN_SCRIPT)" install

checkcmd:
ifeq ($(CURRENT_SHELL),bash)
	@echo "Checking commands in .bashrc..."
	@if [ -f $(REPO_ROOT)/bash/.bashrc ]; then \
		grep -vE '^(#|$$|function |[[:space:]]*#)' $(REPO_ROOT)/bash/.bashrc | \
		sed -e 's/#.*//' -e 's/"[^"]*"//g' -e "s/'[^']*'//g" | \
		tr '|&;()<>=' '\n' | awk '{print $$1}' | \
		grep -E '^[[:alpha:]]' | grep -vE '^(if|then|else|fi|for|while|do|done|export|return|alias|eval|source|\.|/|~)' | \
		sort -u | while read cmd; do \
			command -v "$$cmd" >/dev/null 2>&1 && echo "[✓] $$cmd" || :; \
		done; \
	else \
		echo "Error: .bashrc not found"; \
	fi
else
	@echo "Current shell is not bash (found: $(CURRENT_SHELL)), skipping command check"
endif

bash:
	@sh "$(DOTFILES_SCRIPT)" install bash

vim:
	@sh "$(DOTFILES_SCRIPT)" install vim
	@sh "$(VIM_PLUGIN_SCRIPT)" install

vim-update:
	@sh "$(VIM_PLUGIN_SCRIPT)" update

clean:
	@sh "$(DOTFILES_SCRIPT)" clean

backup:
	@sh "$(DOTFILES_SCRIPT)" backup

update:
	@git -C "$(REPO_ROOT)" pull --ff-only

.PHONY: all install bash vim vim-update clean backup update checkcmd
