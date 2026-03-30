#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Files/dirs in dotfiles root to never symlink
IGNORE=(".git" ".gitignore" ".DS_Store" "init.sh" "symlink.sh" "README.md")

# Dirs whose *children* get symlinked one level deeper into the corresponding $HOME subdir.
# e.g. dotfiles/.config/opencode  ->  ~/.config/opencode
#      dotfiles/.config/starship  ->  ~/.config/starship
NESTED=(".config")

# ── helpers ──────────────────────────────────────────────────────────────────

info()    { printf '  \033[0;34m[symlink]\033[0m %s\n' "$*"; }
success() { printf '  \033[0;32m[symlink]\033[0m %s\n' "$*"; }
warn()    { printf '  \033[0;33m[symlink]\033[0m %s\n' "$*"; }
error()   { printf '  \033[0;31m[symlink]\033[0m %s\n' "$*" >&2; }

in_list() {
  local needle="$1"; shift
  local item
  for item in "$@"; do [[ "$item" == "$needle" ]] && return 0; done
  return 1
}

# Link $1 (source) to $2 (dest), idempotently.
# - Already correct symlink  → skip (no-op)
# - Stale/wrong symlink       → re-link
# - Real file/dir in the way  → back it up then link
make_link() {
  local src="$1"
  local dest="$2"

  # Already pointing at the right place — nothing to do
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    info "already linked: $dest"
    return
  fi

  # Stale or wrong symlink — remove and re-link
  if [[ -L "$dest" ]]; then
    warn "re-linking stale symlink: $dest"
    rm "$dest"
  # Real file or directory in the way — back it up
  elif [[ -e "$dest" ]]; then
    local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    warn "backing up existing file: $dest → $backup"
    mv "$dest" "$backup"
  fi

  # Ensure parent directory exists
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  success "linked: $dest → $src"
}

# ── main ─────────────────────────────────────────────────────────────────────

info "dotfiles dir: $DOTFILES_DIR"
info "home dir:     $HOME"
echo

# Iterate dotfiles root with nullglob to safely handle empty dirs
shopt -s nullglob dotglob
for src in "$DOTFILES_DIR"/*; do
  file="$(basename "$src")"

  # Skip ignored entries
  in_list "$file" "${IGNORE[@]}" && continue

  # Nested dirs: symlink each child one level deeper
  if in_list "$file" "${NESTED[@]}"; then
    dest_parent="$HOME/$file"
    mkdir -p "$dest_parent"
    for child_src in "$src"/*; do
      [[ "$(basename "$child_src")" == ".DS_Store" ]] && continue
      make_link "$child_src" "$dest_parent/$(basename "$child_src")"
    done
    continue
  fi

  # Everything else: symlink directly into $HOME
  make_link "$src" "$HOME/$file"
done

echo
success "done."
