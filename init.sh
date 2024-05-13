#!/bin/bash

# for the files in this dir, add a symlink to the home dir
for i in $(ls); do 
	echo "$(pwd)/$i"; 
	ln -s "$(pwd)/$i" "$HOME/.$i"; 
done

# install antigen plugin manager
curl -L git.io/antigen > "$HOME"/antigen.zsh
