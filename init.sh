#!/usr/bin/env bash
# init.sh — idempotent dotfiles bootstrap
# Safe to re-run at any time (sync mode): re-links symlinks, skips already-installed tools.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── helpers ──────────────────────────────────────────────────────────────────

info()    { printf '\n\033[0;34m==>\033[0m %s\n' "$*"; }
success() { printf '  \033[0;32m✓\033[0m %s\n' "$*"; }
warn()    { printf '  \033[0;33m!\033[0m %s\n' "$*"; }
skip()    { printf '  \033[0;90m–\033[0m %s (already installed, skipping)\n' "$*"; }

# Returns 0 if a command exists
has() { command -v "$1" &>/dev/null; }

# Detects OS: "macos" | "linux"
os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    *)      echo "unknown" ;;
  esac
}

# ── symlinks ─────────────────────────────────────────────────────────────────

info "Setting up symlinks"
bash "$DOTFILES_DIR/symlink.sh"

# ── shell: zsh ───────────────────────────────────────────────────────────────

info "Shell: zsh"
if [[ "$(os)" == "linux" ]]; then
  if ! has zsh; then
    info "Installing zsh (apt)"
    sudo apt-get install -y zsh
    success "zsh installed"
  else
    skip "zsh"
  fi

  if [[ "$SHELL" != "$(which zsh)" ]]; then
    info "Setting zsh as default shell"
    chsh -s "$(which zsh)"
    success "default shell changed to zsh (re-login to apply)"
  else
    skip "zsh default shell"
  fi
elif [[ "$(os)" == "macos" ]]; then
  # zsh ships with macOS; just verify it's the default
  if [[ "$SHELL" != "/bin/zsh" && "$SHELL" != "$(which zsh)" ]]; then
    warn "zsh is not your default shell. Run: chsh -s \$(which zsh)"
  else
    skip "zsh (macOS built-in)"
  fi
fi

# ── antigen ───────────────────────────────────────────────────────────────────

info "Antigen (zsh plugin manager)"
if [[ ! -f "$HOME/antigen.zsh" ]]; then
  curl -fsSL git.io/antigen -o "$HOME/antigen.zsh"
  success "antigen downloaded"
else
  skip "antigen"
fi

# ── starship ─────────────────────────────────────────────────────────────────

info "Starship (prompt)"
if ! has starship; then
  curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
  success "starship installed"
else
  skip "starship"
fi

# ── package managers ─────────────────────────────────────────────────────────

info "Homebrew"
if [[ "$(os)" == "macos" ]] || [[ "$(os)" == "linux" ]]; then
  if ! has brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    success "homebrew installed"
  else
    skip "homebrew"
  fi
fi

# ── language version managers ────────────────────────────────────────────────

info "pyenv (Python version manager)"
if ! has pyenv; then
  curl -fsSL https://pyenv.run | bash
  success "pyenv installed"
else
  skip "pyenv"
fi

info "nvm (Node version manager)"
if [[ ! -d "$HOME/.nvm" ]]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  success "nvm installed"
else
  skip "nvm"
fi

# ── gh cli + copilot ─────────────────────────────────────────────────────────

info "GitHub CLI"
if ! has gh; then
  if [[ "$(os)" == "macos" ]]; then
    brew install gh
  elif [[ "$(os)" == "linux" ]]; then
    sudo apt-get install -y gh 2>/dev/null || brew install gh
  fi
  success "gh installed"
else
  skip "gh"
fi

info "GitHub Copilot CLI extension"
if ! gh extension list 2>/dev/null | grep -q "gh-copilot"; then
  # Only attempt if already authenticated; otherwise remind the user
  if gh auth status &>/dev/null; then
    gh extension install github/gh-copilot --force
    success "gh copilot extension installed"
  else
    warn "gh is not authenticated. Run 'gh auth login --web' then re-run this script."
  fi
else
  skip "gh copilot extension"
fi

# ── done ─────────────────────────────────────────────────────────────────────

info "Done"
printf '\n  All tools are installed and symlinks are up to date.\n'
printf '  Re-run this script at any time to sync.\n\n'
