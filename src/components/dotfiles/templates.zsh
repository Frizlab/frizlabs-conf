# Detemplatize the templates and put them at the correct location
for template in "${DOTFILE_TEMPLATES[@]}"; do
	dest_file="$HOME/$template"
	repo_file="$(pwd)/templates/_$template.m4"
	start_task "template ${dest_file/#$HOME/\~}"
	catchout RES   libtemplates__detemplate "$repo_file" "$dest_file" "600"
	log_task_from_res "$RES"
done
