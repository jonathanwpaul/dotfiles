ignore_list=("init.sh" "symlink.sh" ".git" ".gitignore")

for file in $(ls -A ~/dotfiles); do
	if ! [[ " ${ignore_list[*]} " =~ " $file " ]]; then
		src="$HOME/dotfiles/$file"
		dest="$HOME/$file"
		if [ -d "$src" ]; then
			mkdir -p "$dest"
			for child in $(ls -A "$src"); do
				ln -s "$src/$child" "$dest/$child"
			done
		else
			ln -s "$src" "$dest"
		fi
	fi
done
