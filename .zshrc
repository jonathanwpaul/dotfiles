# Speed up antigen by enabling its cache
export ANTIGEN_CACHE=~/.cache/antigen/init.zsh
export ANTIGEN_COMPDUMPFILE=~/.cache/antigen/zcompdump
mkdir -p ~/.cache/antigen

source ~/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

# alias
antigen bundle djui/alias-tips

# ghcp
antigen bundle loiccoyle/zsh-github-copilot@main

# autosuggestions
antigen bundle zsh-users/zsh-autosuggestions

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

antigen bundle zsh-users/zsh-history-substring-search
# Load the theme.
eval "$(starship init zsh)"

# Tell Antigen that you're done.
antigen apply

# my custom aliases
source ~/.alias

#Add the following to your shell profile e.g. ~/.profile or ~/.zshrc:
# nvm — lazy-load to avoid startup penalty
export NVM_DIR="$HOME/.nvm"
_load_nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm()  { _load_nvm; nvm  "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm  "$@"; }
npx()  { _load_nvm; npx  "$@"; }

# pyenv — lazy-load to avoid startup penalty
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
_load_pyenv() {
  unset -f python python3 pip pip3 pyenv
  eval "$(pyenv init -)"
}
pyenv()   { _load_pyenv; pyenv   "$@"; }
python()  { _load_pyenv; python  "$@"; }
python3() { _load_pyenv; python3 "$@"; }
pip()     { _load_pyenv; pip     "$@"; }
pip3()    { _load_pyenv; pip3    "$@"; }
export PATH="$PATH:/opt/homebrew/bin"

export LESS="-SRXF"
export EDITOR='nvim'
export VISUAL='nvim'

#needed for platformio
export PATH=$PATH:$HOME/.platformio/penv/bin

eval "$(/opt/homebrew/bin/brew shellenv)"

# pnpm
export PNPM_HOME="/Users/jonpaul/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
