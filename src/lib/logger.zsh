typeset -g CURRENT_COMPONENT_NAME

typeset -gA COMPONENTS_STATS_OKS
typeset -gA COMPONENTS_STATS_ERRORS
typeset -gA COMPONENTS_STATS_CHANGES
typeset -gA COMPONENTS_STATS_WARNINGS

# Log the command and run it. Also logs the command’s output, prefixing by stdout or stderr. Drop real stdout and stderr.
function run_and_log() {
	print -- "\n--- RUNNING $@" | tee -a "$RUN_LOG" "$VERBOSE_OUTPUT" >/dev/null
	"$@" > >(sed -E 's/^/-> stdout: /' | tee -a "$RUN_LOG" "$VERBOSE_OUTPUT" >/dev/null) 2> >(sed -E 's/^/-> stderr: /' | tee -a "$RUN_LOG" "$VERBOSE_OUTPUT" >/dev/null)
	local -r res="$?"
	print -- "--- DONE ($res)" | tee -a "$RUN_LOG" "$VERBOSE_OUTPUT" >/dev/null
	return "$res"
}
# Same as previous, but real stdout is kept (in addition to being logged). stderr is still dropped.
function run_and_log_keep_stdout() {
	print -- "\n--- RUNNING $@" | tee -a "$RUN_LOG" "$VERBOSE_OUTPUT" >/dev/null
	"$@" 2> >(sed -E 's/^/-> stderr: /' | tee -a "$RUN_LOG" "$VERBOSE_OUTPUT" >/dev/null) | tee >(sed -E 's/^/-> stdout: /' | tee -a "$RUN_LOG" "$VERBOSE_OUTPUT" >/dev/null)
	local -r res="$?"
	print -- "--- DONE ($res)" | tee -a "$RUN_LOG" "$VERBOSE_OUTPUT" >/dev/null
	return "$res"
}

# Usage: log_component_start component_name
function log_component_start() {
	CURRENT_COMPONENT_NAME="$1"
	
	COMPONENTS_STATS_OKS[$CURRENT_COMPONENT_NAME]=0
	COMPONENTS_STATS_ERRORS[$CURRENT_COMPONENT_NAME]=0
	COMPONENTS_STATS_CHANGES[$CURRENT_COMPONENT_NAME]=0
	COMPONENTS_STATS_WARNINGS[$CURRENT_COMPONENT_NAME]=0
	
	print -- "------- STARTING INSTALL OF “$CURRENT_COMPONENT_NAME” -------\n\n" >>"$RUN_LOG"
	log_line "Installing " $CURRENT_COMPONENT_NAME
}

# Usage: log_component_end
function log_component_end() {
	print -- "\n\n------- FINISHED INSTALL OF “$CURRENT_COMPONENT_NAME”\n\n\n\n" >>"$RUN_LOG"
	CURRENT_COMPONENT_NAME=
	print >&2
}

# This function should be somewhere else, I guess…
function start_task() {
	# Set the global variables
	RES=; RES_LIST=()
	CURRENT_TASK_NAME="$1"
	log_task_start
}

function log_task_start() {
	print -- "\n----- STARTING TASK $CURRENT_TASK_NAME" >>"$RUN_LOG"
	print -Pn -- "%F{yellow}%Bin progress%b: $CURRENT_TASK_NAME%f" >&2
}

# For up-to-date tasks (did not need to do anything)
function log_task_ok() {
	COMPONENTS_STATS_OKS[$CURRENT_COMPONENT_NAME]=$((COMPONENTS_STATS_OKS[$CURRENT_COMPONENT_NAME] + 1))
	print -- "\n----- TASK SUCCEEDED WITH NO CHANGES\n" >>"$RUN_LOG"
	print -P -- "\r\033[2K%F{green}%Bok%b: $CURRENT_TASK_NAME%f" >&2
}

# For tasks that needed an update
function log_task_change() {
	COMPONENTS_STATS_CHANGES[$CURRENT_COMPONENT_NAME]=$((COMPONENTS_STATS_CHANGES[$CURRENT_COMPONENT_NAME] + 1))
	print -- "\n----- TASK SUCCEEDED WITH CHANGES\n" >>"$RUN_LOG"
	print -P -- "\r\033[2K%F{cyan}%Bchanged%b: $CURRENT_TASK_NAME%f" >&2
}

# For tasks that did not fail, but had a warning
function log_task_warning() {
	COMPONENTS_STATS_WARNINGS[$CURRENT_COMPONENT_NAME]=$((COMPONENTS_STATS_WARNINGS[$CURRENT_COMPONENT_NAME] + 1))
	
	local -r warning_message="$1"
	print -- "\n----- TASK SUCCEEDED WITH WARNING: $warning_message\n" >>"$RUN_LOG"
	print -P -- "\r\033[2K%F{yellow}%Bwarning%b: $CURRENT_TASK_NAME: $warning_message%f" >&2
}

# For tasks that failed
function log_task_failure() {
	COMPONENTS_STATS_ERRORS[$CURRENT_COMPONENT_NAME]=$((COMPONENTS_STATS_ERRORS[$CURRENT_COMPONENT_NAME] + 1))
	
	local -r error_message="$1"
	print -- "\n----- TASK FAILED: $error_message\n" >>"$RUN_LOG"
	print -P -- "\r\033[2K%F{red}%Bfailed%b: $CURRENT_TASK_NAME: $error_message%f" >&2
}

function log_task_from_res_list() {
	local -r res_list_name="$1"
	
	local highest_res=
	for res in ${(P)${res_list_name}}; do
		case "$highest_res:$res" in
			:*)             highest_res="$res";;
			failed:*)       highest_res="failed";;
			changed:failed) highest_res="failed";;
			changed:*)      highest_res="changed";;
			ok:failed)      highest_res="failed";;
			ok:changed)     highest_res="changed";;
			*)              highest_res="ok";;
		esac
	done
	log_task_from_res "$highest_res"
}

function log_task_from_res() {
	local -r res="$1"
	case "$res" in
		"ok")      log_task_ok;;
		"changed") log_task_change;;
		"failed")  ;; # Must have been logged before
	esac
}

function log_line() {
	local -r prefix="$1"
	local -r bold="$2"
	local -r line_char="${3:-*}"
	local -r str="$prefix$bold"
	local -r w=$#str
	local -r n=$((TERM_WIDTH - w - 1))
	print -Pn -- "$prefix%B$bold%b " >&2
	test $n -gt 0 && printf %"$n"s | tr " " "$line_char" >&2
	print >&2
}

function res_check() {
	test -z "$1" -o "$1" = "ok" -o "$1" = "changed"
}
