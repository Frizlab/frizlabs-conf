# Create the folders the different dotfiles expect (extension points).
for folder in "${DOTFILES__FOLDERS[@]}"; do
	task__folder "$HOME/$folder" "700"
done
