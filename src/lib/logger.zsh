typeset -g CURRENT_COMPONENT_NAME

typeset -gA COMPONENTS_STATS_ERRORS
typeset -gA COMPONENTS_STATS_WARNINGS
typeset -gA COMPONENTS_STATS_SUCCESSES

# Usage: log_component_start task_name
function log_component_start() {
	CURRENT_COMPONENT_NAME="$1"
	
	COMPONENTS_STATS_ERRORS[$CURRENT_COMPONENT_NAME]=0
	COMPONENTS_STATS_WARNINGS[$CURRENT_COMPONENT_NAME]=0
	COMPONENTS_STATS_SUCCESSES[$CURRENT_COMPONENT_NAME]=0
	
	log_line "Installing " $CURRENT_COMPONENT_NAME
}

# Usage: log_component_end
function log_component_end() {
	CURRENT_COMPONENT_NAME=
	print
}

function log_task_success() {
	COMPONENTS_STATS_SUCCESSES[$CURRENT_COMPONENT_NAME]=$((COMPONENTS_STATS_SUCCESSES[CURRENT_COMPONENT_NAME] + 1))
	print -P "%F{green}%Bok%b: $CURRENT_TASK_NAME%f"
}

function log_task_warning() {
	COMPONENTS_STATS_WARNINGS[$CURRENT_COMPONENT_NAME]=$((COMPONENTS_STATS_WARNINGS[CURRENT_COMPONENT_NAME] + 1))
	
	warning_message="$1"
	print -P "%F{yellow}%Bwarning%b: $CURRENT_TASK_NAME: $warning_message%f"
}

function log_task_failure() {
	COMPONENTS_STATS_ERRORS[$CURRENT_COMPONENT_NAME]=$((COMPONENTS_STATS_ERRORS[CURRENT_COMPONENT_NAME] + 1))
	
	error_message="$1"
	print -P "%F{red}%Bfailed%b: $CURRENT_TASK_NAME: $error_message%f"
}

function log_line() {
	prefix="$1"
	bold="$2"
	str="$prefix$bold"
	w=$#str
	n=$((TERM_WIDTH - w - 1))
	print -Pn "$prefix%B$bold%b "
	test $n -gt 0 && printf %"$n"s | tr " " "*"
	print
}
