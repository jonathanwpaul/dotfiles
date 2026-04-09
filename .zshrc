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

export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export LESS="-SRXF"
export EDITOR='nvim'
export VISUAL='nvim'

#needed for platformio
export PATH=$PATH:$HOME/.platformio/penv/bin
# pnpm
export PNPM_HOME="/Users/jonpaul/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# opencode
export PATH=/home/jonathan/.opencode/bin:$PATH

case "$(uname -s)" in
    Darwin)
        echo "Detected: macOS"
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export PATH="$PATH:/opt/homebrew/bin"
        ;;
    Linux)
        echo "Detected: Linux"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
        ;;
    *)
        echo "Unknown Operating System"
        exit 1
        ;;
esac

export PATH="$HOME/.local/bin:$PATH"
