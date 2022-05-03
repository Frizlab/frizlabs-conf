# Nothing to be done if the defaults command is not available.
# We still print ok in a dummy task to have a more beautiful output.
if ! command -v defaults >/dev/null 2>&1; then
	start_task "defaults is not available (we’re probably not on macOS); skipping this component…"
	log_task_from_res "ok"
else
	source "./tasks/set-defaults.zsh"
fi
