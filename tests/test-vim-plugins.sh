#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp/home/.vim/autoload" "$tmp/bin"
touch "$tmp/home/.vimrc" "$tmp/home/.vim/autoload/plug.vim"
cat > "$tmp/bin/vim" <<'FAKE_VIM'
#!/bin/sh
printf '%s\n' "$DOTFILES_VIM_PLUGIN_ACTION" >> "$DOTFILES_TEST_LOG"
case "$DOTFILES_VIM_PLUGIN_ACTION" in
  install|update) exit 0 ;;
  *) exit 1 ;;
esac
FAKE_VIM
chmod +x "$tmp/bin/vim"
export HOME="$tmp/home" PATH="$tmp/bin:$PATH" DOTFILES_TEST_LOG="$tmp/actions"
sh "$repo_root/scripts/vim-plugins.sh" install
sh "$repo_root/scripts/vim-plugins.sh" update
[ "$(sed -n '1p' "$tmp/actions")" = install ]
[ "$(sed -n '2p' "$tmp/actions")" = update ]
[ "$(wc -l < "$tmp/actions")" -eq 2 ]

# Any Vim execution error must fail the command.
cat > "$tmp/bin/vim" <<'FAKE_VIM_FAILURE'
#!/bin/sh
exit 19
FAKE_VIM_FAILURE
chmod +x "$tmp/bin/vim"
if sh "$repo_root/scripts/vim-plugins.sh" install >/dev/null 2>&1; then
  echo 'Failed Vim must fail installation' >&2
  exit 1
fi

# Make targets invoke the wrapper as expected, without using the network.
: > "$tmp/actions"
cat > "$tmp/bin/vim" <<'FAKE_VIM_WORKING'
#!/bin/sh
printf '%s\n' "$DOTFILES_VIM_PLUGIN_ACTION" >> "$DOTFILES_TEST_LOG"
exit 0
FAKE_VIM_WORKING
chmod +x "$tmp/bin/vim"
make -s -C "$repo_root" vim
make -s -C "$repo_root" vim-update
SHELL=/bin/bash make -s -C "$repo_root" install
[ "$(sed -n '1p' "$tmp/actions")" = install ]
[ "$(sed -n '2p' "$tmp/actions")" = update ]
[ "$(sed -n '3p' "$tmp/actions")" = install ]
[ "$(wc -l < "$tmp/actions")" -eq 3 ]

printf 'vim plugin integration tests passed\n'
