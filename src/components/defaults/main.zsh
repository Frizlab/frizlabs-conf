# Setup some macOS defaults

# Nothing to be done if not on macOS! We still print ok for a dummy task for
# the aesthetic of the output
if test "$HOST_OS" != "Darwin"; then
	CURRENT_TASK_NAME="dummy (not on macOS)"
	log_task_from_res "ok"
else
	source "./defaults.zsh"
fi
