#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT HUP INT TERM
export HOME="$tmp/home"
mkdir -p "$HOME/.vim"
printf 'original bash\n' > "$HOME/.bashrc"
printf 'original profile\n' > "$HOME/.bash_profile"
printf 'original vimrc\n' > "$HOME/.vimrc"
printf 'important data\n' > "$HOME/.vim/keep-me"

sh "$repo_root/scripts/dotfiles.sh" install bash vim
for file in .bashrc .bash_profile .vimrc .vim; do
  [ -L "$HOME/$file" ] || { echo "Expected link: $file" >&2; exit 1; }
done
set -- "$HOME"/.dotfiles_backup/install.*
[ "$#" -eq 1 ] && [ -d "$1" ]
backup_dir=$1
[ "$(cat "$backup_dir/.bashrc")" = 'original bash' ]
[ "$(cat "$backup_dir/.bash_profile")" = 'original profile' ]
[ "$(cat "$backup_dir/.vimrc")" = 'original vimrc' ]
[ "$(cat "$backup_dir/.vim/keep-me")" = 'important data' ]

# Installing matching links must not add another backup.
sh "$repo_root/scripts/dotfiles.sh" install bash vim
set -- "$HOME"/.dotfiles_backup/install.*
[ "$#" -eq 1 ]

# Existing regular files and foreign symlinks must survive cleanup.
rm -- "$HOME/.bashrc"
printf 'user content\n' > "$HOME/.bashrc"
rm -- "$HOME/.vimrc"
ln -s -- "$backup_dir/.vimrc" "$HOME/.vimrc"
sh "$repo_root/scripts/dotfiles.sh" clean
[ "$(cat "$HOME/.bashrc")" = 'user content' ]
[ -L "$HOME/.vimrc" ]
[ ! -e "$HOME/.bash_profile" ] && [ ! -L "$HOME/.bash_profile" ]
[ ! -e "$HOME/.vim" ] && [ ! -L "$HOME/.vim" ]

# A pre-existing directory must never be removed by clean.
mkdir "$HOME/.vim"
printf 'data\n' > "$HOME/.vim/keep-me"
sh "$repo_root/scripts/dotfiles.sh" clean
[ "$(cat "$HOME/.vim/keep-me")" = 'data' ]

# Explicit backups copy instead of moving the original.
sh "$repo_root/scripts/dotfiles.sh" backup
[ "$(cat "$HOME/.bashrc")" = 'user content' ]
set -- "$HOME"/.dotfiles_backup/install.*
[ "$#" -eq 2 ]

# Reject a backup destination that is itself a symlink.
other_home="$tmp/other-home"
mkdir -p "$other_home"
ln -s "$backup_dir" "$other_home/.dotfiles_backup"
printf 'existing\n' > "$other_home/.bashrc"
if HOME="$other_home" sh "$repo_root/scripts/dotfiles.sh" install bash > /dev/null 2>&1; then
  echo 'Unexpected successful install with symlinked backup directory' >&2
  exit 1
fi

printf 'dotfiles safety tests passed\n'
