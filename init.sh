#!/bin/bash
# install zsh
sudo apt install zsh
chsh -s $(which zsh)

# for the files in this dir, add a symlink to the home dir
for i in $(ls); do 
	echo "$(pwd)/$i"; 
	ln -s "$(pwd)/$i" "$HOME/.$i"; 
done

# install antigen plugin manager
curl -L git.io/antigen > "$HOME"/antigen.zsh
source "$HOME"/antigen.zsh

# install starship theming
curl -sS https://starship.rs/install.sh | sh
mkdir -p ~/.config && touch ~/.config/starship.toml
#starship preset gruvbox-rainbow -o ~/.config/starship.toml
starship preset jetpack -o ~/.config/starship.toml
