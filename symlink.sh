ignore_list=("init.sh" "symlink.sh" ".git" ".gitignore")

# Directories whose children should be symlinked one level deeper
# e.g. dotfiles/.config/opencode -> ~/.config/opencode
nested_dirs=(".config")

for file in $(ls -A ~/dotfiles); do
	if ! [[ " ${ignore_list[*]} " =~ " $file " ]]; then
		src="$HOME/dotfiles/$file"
		dest="$HOME/$file"
		if [[ " ${nested_dirs[*]} " =~ " $file " ]]; then
			# For nested dirs, symlink each child into the corresponding $HOME subdir
			mkdir -p "$dest"
			for child in $(ls -A "$src"); do
				ln -sf "$src/$child" "$dest/$child"
			done
		elif [ -d "$src" ]; then
			mkdir -p "$dest"
			for child in $(ls -A "$src"); do
				ln -sf "$src/$child" "$dest/$child"
			done
		else
			ln -sf "$src" "$dest"
		fi
	fi
done
