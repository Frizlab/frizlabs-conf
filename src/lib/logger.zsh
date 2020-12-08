typeset -g CURRENT_COMPONENT_NAME

typeset -gA COMPONENTS_STATS_OKS
typeset -gA COMPONENTS_STATS_ERRORS
typeset -gA COMPONENTS_STATS_CHANGES
typeset -gA COMPONENTS_STATS_WARNINGS

# Usage: log_component_start task_name
function log_component_start() {
	CURRENT_COMPONENT_NAME="$1"
	
	COMPONENTS_STATS_OKS[$CURRENT_COMPONENT_NAME]=0
	COMPONENTS_STATS_ERRORS[$CURRENT_COMPONENT_NAME]=0
	COMPONENTS_STATS_CHANGES[$CURRENT_COMPONENT_NAME]=0
	COMPONENTS_STATS_WARNINGS[$CURRENT_COMPONENT_NAME]=0
	
	log_line "Installing " $CURRENT_COMPONENT_NAME
}

# Usage: log_component_end
function log_component_end() {
	CURRENT_COMPONENT_NAME=
	print >&2
}

# For up-to-date tasks (did not need to do anything)
function log_task_ok() {
	COMPONENTS_STATS_OKS[$CURRENT_COMPONENT_NAME]=$((COMPONENTS_STATS_OKS[$CURRENT_COMPONENT_NAME] + 1))
	print -P "%F{green}%Bok%b: $CURRENT_TASK_NAME%f" >&2
}

function log_task_change() {
	COMPONENTS_STATS_CHANGES[$CURRENT_COMPONENT_NAME]=$((COMPONENTS_STATS_CHANGES[$CURRENT_COMPONENT_NAME] + 1))
	print -P "%F{cyan}%Bchanged%b: $CURRENT_TASK_NAME%f" >&2
}

function log_task_warning() {
	COMPONENTS_STATS_WARNINGS[$CURRENT_COMPONENT_NAME]=$((COMPONENTS_STATS_WARNINGS[$CURRENT_COMPONENT_NAME] + 1))
	
	warning_message="$1"
	print -P "%F{yellow}%Bwarning%b: $CURRENT_TASK_NAME: $warning_message%f" >&2
}

function log_task_failure() {
	COMPONENTS_STATS_ERRORS[$CURRENT_COMPONENT_NAME]=$((COMPONENTS_STATS_ERRORS[$CURRENT_COMPONENT_NAME] + 1))
	
	error_message="$1"
	print -P "%F{red}%Bfailed%b: $CURRENT_TASK_NAME: $error_message%f" >&2
}

function log_task_from_res_list() {
	local res_list_name="$1"
	
	highest_res=
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
	case "$highest_res" in
		"ok")      log_task_ok;;
		"changed") log_task_change;;
		"failed")  ;; # Must have been logged before
	esac
}

function log_line() {
	prefix="$1"
	bold="$2"
	str="$prefix$bold"
	w=$#str
	n=$((TERM_WIDTH - w - 1))
	print -Pn "$prefix%B$bold%b " >&2
	test $n -gt 0 && printf %"$n"s | tr " " "*" >&2
	print >&2
}

function res_check() {
	test -z "$1" -o "$1" = "ok" -o "$1" = "changed"
}
