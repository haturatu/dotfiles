# dotfiles

Bash and Vim configurations installed as symbolic links.

## Before installing

Optionally check the commands used in `.bashrc`:

```sh
make checkcmd
```

## Install

```sh
make install   # Vim and, when your login shell is Bash, Bash
make bash      # Bash only
make vim       # Vim only
```

If any destination already exists (including a directory or an existing symlink),
it is **moved to a unique directory** under `~/.dotfiles_backup/install.*`
before creating the new link. Re-running an installation on matching links is safe
and will not create unnecessary backups. Installation does not delete the old
configuration. Inspect the backup directory before removing it.

You can also create a separate, manual backup of the current configuration:

```sh
make backup
```

This copies `.bashrc`, `.bash_profile`, `.vimrc`, and `.vim` (when present)
into a new `~/.dotfiles_backup/install.*` directory. Existing symlinks are
copied as symlinks rather than followed.

Vim plugins are managed by [vim-plug](https://github.com/junegunn/vim-plug).
After installing the Vim configuration, run `:PlugInstall` in Vim to install
the plugins declared in `.vimrc`. The plugin working tree is not tracked by Git.

## Remove or restore

```sh
make clean
```

`make clean` removes **only** symbolic links that still point at this repository's
managed files. It does not delete ordinary files, directories, or unrelated
symlinks, and it does not automatically restore backups.

To restore a previous configuration, run `make clean`, then copy or move the
relevant entries back from the appropriate `~/.dotfiles_backup/install.*`
directory. Be sure to choose the correct backup if you have run the installer
more than once.

## Update

```sh
make update
```

This runs `git pull --ff-only` in the dotfiles repository. It does **not** copy
files from your home directory into the repository, commit changes, or push to
GitHub. Make changes in the repository and use Git explicitly to commit/push.

## Available commands

| Command | Description |
| --- | --- |
| `make all` / `make install` | Install Vim and Bash when the login shell is Bash. |
| `make bash` | Install Bash configuration only. |
| `make vim` | Install Vim configuration only. |
| `make checkcmd` | Check known commands referenced in `.bashrc`. |
| `make backup` | Copy the current settings into a new backup directory. |
| `make clean` | Remove only managed symbolic links. |
| `make update` | Fast-forward pull the repository without committing or pushing. |
