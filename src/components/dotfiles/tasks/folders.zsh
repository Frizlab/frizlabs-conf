# Create the folders the different dotfiles expect.
for folder in "${DOTFILES__FOLDERS[@]}"; do
	task__folder "$HOME/$folder" "700"
done
