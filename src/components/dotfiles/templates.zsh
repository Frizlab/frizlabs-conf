# Detemplatize the templates and put them at the correct location
for template in $DOTFILE_TEMPLATES; do
	dest_file="$HOME/$template"
	repo_file="$(pwd)/templates/_$template.m4"
	CURRENT_TASK_NAME="template $dest_file"
	catchout res   detemplate "$repo_file" "$dest_file" "600"
	log_task_from_res "$res"
done
