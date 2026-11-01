#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
: "${HOME:?HOME must be set}"
backup_root="$HOME/.dotfiles_backup"
backup_dir=

prepare_backup() {
  if [ -L "$backup_root" ]; then
    echo "Refusing symlinked backup directory: $backup_root" >&2
    exit 1
  fi
  mkdir -p -m 700 -- "$backup_root"
  if [ -z "$backup_dir" ]; then
    backup_dir=$(mktemp -d "$backup_root/install.XXXXXXXX")
    printf 'Backups: %s\n' "$backup_dir"
  fi
}

install_link() {
  src=$1
  dest=$2

  if [ ! -e "$src" ]; then
    printf 'Missing source: %s\n' "$src" >&2
    return 1
  fi
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    printf 'Already installed: %s\n' "$dest"
    return 0
  fi

  backed_up=no
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    prepare_backup
    mv -- "$dest" "$backup_dir/$(basename "$dest")"
    backed_up=yes
  fi

  if ! ln -s -- "$src" "$dest"; then
    if [ "$backed_up" = yes ]; then
      mv -- "$backup_dir/$(basename "$dest")" "$dest"
    fi
    return 1
  fi
  printf 'Installed: %s\n' "$dest"
}

clean_link() {
  src=$1
  dest=$2
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    rm -- "$dest"
    printf 'Removed: %s\n' "$dest"
  elif [ -e "$dest" ] || [ -L "$dest" ]; then
    printf 'Skipped unmanaged path: %s\n' "$dest"
  fi
}

backup_one() {
  target=$1
  if [ -e "$target" ] || [ -L "$target" ]; then
    prepare_backup
    cp -a -- "$target" "$backup_dir/$(basename "$target")"
  fi
}

case "${1:-}" in
  install)
    shift
    if [ "$#" -eq 0 ]; then
      echo 'Usage: dotfiles.sh install bash|vim [bash|vim ...]' >&2
      exit 2
    fi
    for group in "$@"; do
      case "$group" in
        bash)
          install_link "$repo_root/bash/.bashrc" "$HOME/.bashrc"
          install_link "$repo_root/bash/.bash_profile" "$HOME/.bash_profile"
          ;;
        vim)
          install_link "$repo_root/vim/.vimrc" "$HOME/.vimrc"
          install_link "$repo_root/vim/.vim" "$HOME/.vim"
          ;;
        *) printf 'Unknown group: %s\n' "$group" >&2; exit 2 ;;
      esac
    done
    ;;
  clean)
    clean_link "$repo_root/bash/.bashrc" "$HOME/.bashrc"
    clean_link "$repo_root/bash/.bash_profile" "$HOME/.bash_profile"
    clean_link "$repo_root/vim/.vimrc" "$HOME/.vimrc"
    clean_link "$repo_root/vim/.vim" "$HOME/.vim"
    ;;
  backup)
    backup_one "$HOME/.bashrc"
    backup_one "$HOME/.bash_profile"
    backup_one "$HOME/.vimrc"
    backup_one "$HOME/.vim"
    ;;
  *)
    echo 'Usage: dotfiles.sh {install bash|vim,clean,backup}' >&2
    exit 2
    ;;
esac
