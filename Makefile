PWD := $(shell pwd)
HOME := $(shell echo $$HOME)

all: install

install: bash vim

checkcmd:
	@echo "Checking commands in .bashrc..."
	@if [ -f $(PWD)/bash/.bashrc ]; then \
		grep -vE '^(#|$|function |[[:space:]]*#)' $(PWD)/bash/.bashrc | \
		sed -e 's/#.*//' -e 's/"[^"]*"//g' -e "s/'[^']*'//g" | \
		tr '|&;()<>=' '\n' | awk '{print $$1}' | \
		grep -E '^[[:alpha:]]' | grep -vE '^(if|then|else|fi|for|while|do|done|export|return|alias|eval|source|\.|/|~)' | \
		sort -u | while read cmd; do \
			command -v "$$cmd" >/dev/null 2>&1 && echo "[✓] $$cmd" || :; \
		done; \
	else \
		echo "Error: .bashrc not found"; \
	fi

bash:
	@echo "Installing bash configuration..."
	@ln -sf $(PWD)/bash/.bashrc $(HOME)/.bashrc
	@ln -sf $(PWD)/bash/.bash_profile $(HOME)/.bash_profile

vim:
	@echo "Installing vim configuration..."
	@ln -sf $(PWD)/vim/.vimrc $(HOME)/.vimrc
	@ln -sf $(PWD)/vim/.vim $(HOME)/.vim

clean:
	@echo "Removing symlinks..."
	@rm -f $(HOME)/.bashrc
	@rm -f $(HOME)/.bash_profile
	@rm -f $(HOME)/.vimrc
	@rm -rf $(HOME)/.vim
backup:
	@echo "Backing up existing files..."
	@mkdir -p $(HOME)/.dotfiles_backup
	@test -f $(HOME)/.bashrc && cp $(HOME)/.bashrc $(HOME)/.dotfiles_backup/.bashrc.bak || true
	@test -f $(HOME)/.bash_profile && cp $(HOME)/.bash_profile $(HOME)/.dotfiles_backup/.bash_profile.bak || true
	@test -f $(HOME)/.vimrc && cp $(HOME)/.vimrc $(HOME)/.dotfiles_backup/.vimrc.bak || true
	@test -d $(HOME)/.vim && cp -r $(HOME)/.vim $(HOME)/.dotfiles_backup/.vim.bak || true

.PHONY: all install bash vim clean
