#!/bin/sh
set -eu

case "${1:-}" in
  install|update) action=$1 ;;
  *) echo 'Usage: vim-plugins.sh {install|update}' >&2; exit 2 ;;
esac

: "${HOME:?HOME must be set}"
if ! command -v vim >/dev/null 2>&1; then
  echo 'vim is required to install or update Vim plugins' >&2
  exit 1
fi
if ! command -v git >/dev/null 2>&1; then
  echo 'git is required by vim-plug' >&2
  exit 1
fi
if [ ! -f "$HOME/.vimrc" ] || [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  echo 'Vim configuration and vim-plug are required (run make vim first)' >&2
  exit 1
fi

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
printf '%s Vim plugins with vim-plug...\n' "$action"
if ! DOTFILES_VIM_PLUGIN_ACTION="$action" vim -N -n -es -i NONE -u "$HOME/.vimrc" -S "$script_dir/vim-plugins.vim"; then
  echo "Vim plugin $action failed. Check your Vim configuration, dependencies and network access." >&2
  exit 1
fi
printf 'Vim plugin %s complete.\n' "$action"
