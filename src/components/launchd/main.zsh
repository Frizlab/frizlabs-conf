# Nothing to be done if the launchctl command is not available.
# We still print ok in a dummy task to have a more beautiful output.
if ! command -v launchctl >/dev/null 2>&1; then
	start_task "launchctl is not available (probably not on macOS); skipping this component…"
	log_task_from_res "ok"
else
	source "./launchd.zsh"
fi
