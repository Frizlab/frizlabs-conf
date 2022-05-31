#!/bin/zsh -euopipefail

# Install Frizlab’s conf
# Tested on macOS and Debian
# Usage: ./install [-v] [component ...]


##############
# Parse args #
##############

# MUST be either /dev/null or /dev/tty
VERBOSE_OUTPUT="/dev/null"
if [ "${1:-}" = "-v" ]; then
	VERBOSE_OUTPUT="/dev/tty"
	shift
fi
readonly VERBOSE_OUTPUT


################################
# Paths Setup and Verification #
################################

# First define the root folder and cd to it.
# We let basename output its errors if it has any.
test "$(basename "$0")" = "install" || {
	print "This script must be run from the install alias." >&2
	exit 1
}
cd "$(dirname "$0")" || { print "FATAL: cd or dirname failed." >&2; exit 255; }
ROOT_FOLDER="$(pwd)" || { print "FATAL: pwd failed." >&2; exit 255; }; readonly ROOT_FOLDER

# We add our own bins to the path, but agree to use the system or user-defined ones if they are already there.
path+="$PWD/.cache/bin"
# We export PATH in case the variable is not exported yet.
export PATH

# This variable can be used in the components to get the run date.
RUN_DATE="$(date '+%Y.%m.%d-%H:%M:%S')" || { print "FATAL: date failed." >&2; exit 255; }; readonly RUN_DATE

# Let’s define the different paths we will need.
readonly SRC_FOLDER="$ROOT_FOLDER/src"
readonly CACHE_FOLDER="$ROOT_FOLDER/.cache"
readonly LIB_FOLDER="$SRC_FOLDER/lib"
readonly COMPONENTS_FOLDER="$SRC_FOLDER/components"
readonly RUN_LOG="$ROOT_FOLDER/runs/$RUN_DATE.log"

# Import other vars.
source "$LIB_FOLDER/vars-facts.zsh"
source "$LIB_FOLDER/vars-executables.zsh"

# Create the runs and cache folder if needed.
"$MKDIR" -p "$CACHE_FOLDER"     && "$CHMOD" 700 "$CACHE_FOLDER"     || { print "FATAL: $MKDIR or $CHMOD failed." >&2; exit 255; }
"$MKDIR" -p "$ROOT_FOLDER/runs" && "$CHMOD" 700 "$ROOT_FOLDER/runs" || { print "FATAL: $MKDIR or $CHMOD failed." >&2; exit 255; }


#######################
# Imports libs and co #
#######################

### Retrieve required info ###

source "$LIB_FOLDER/input-check-deps.zsh" # Exits the script if some deps are missing.
source "$LIB_FOLDER/input-ccrypt.zsh"
source "$LIB_FOLDER/input-group.zsh"

### Utils ###

source "$LIB_FOLDER/utils-logger.zsh"
source "$LIB_FOLDER/utils-misc.zsh"

### Libs ###

source "$LIB_FOLDER/lib-ccrypt.zsh"

source "$LIB_FOLDER/lib-files.zsh"
source "$LIB_FOLDER/lib-templates.zsh"
source "$LIB_FOLDER/lib-defaults.zsh"
source "$LIB_FOLDER/lib-brew.zsh"

### Tasks ###

source "$LIB_FOLDER/tasks-files.zsh"

### Vars (also imports env-specific vars) ###

source "$SRC_FOLDER/vars/ main.zsh"


##################
# Run components #
##################

# Note: We do **not** handle dependencies…
components_to_run=("$@")
if test ${#components_to_run[@]} -eq 0; then
	components_to_run=("${DEFAULT_COMPONENTS_TO_INSTALL[@]}")
fi

max_component_width=0
typeset -g CURRENT_TASK_NAME
for component in $components_to_run; do
	test $max_component_width -lt $#component && max_component_width=$#component
	COMPONENT_ROOT_FOLDER="$COMPONENTS_FOLDER/$component"
	test -d "$COMPONENT_ROOT_FOLDER" || { print -P "%F{yellow}%BWARNING%b: $component does not exist; skipping...%f\n"; continue }
	log_component_start "$component"
	pushd "$COMPONENT_ROOT_FOLDER"
	source "./tasks/ main.zsh" || fatal "Component “$component” did not exit properly."
	popd
	log_component_end
done


#########
# Recap #
#########

print >&2
log_line "$(printf %"$((max_component_width - 6))"s | tr " " "-") " "RECAP" "-"

typeset -g total_oks=0
typeset -g total_errors=0
typeset -g total_changes=0
typeset -g total_warnings=0
for component in ${(ok)COMPONENTS_STATS_OKS}; do
	print -Pn "%B$component%b: " >&2
	printf %"$((max_component_width - $#component))"s >&2
	# OKs
	total_oks=$((total_oks + COMPONENTS_STATS_OKS[$component]))
	if test $COMPONENTS_STATS_OKS[$component] -gt 0; then print -Pn "%F{green}" >&2; fi
	print -n "ok=$COMPONENTS_STATS_OKS[$component]" >&2
	print -Pn "%f " >&2
	if test $COMPONENTS_STATS_OKS[$component] -lt 100; then print -n " " >&2; fi
	if test $COMPONENTS_STATS_OKS[$component] -lt 10;  then print -n " " >&2; fi
	# Changes
	total_changes=$((total_changes + COMPONENTS_STATS_CHANGES[$component]))
	if test $COMPONENTS_STATS_CHANGES[$component] -gt 0; then print -Pn "%F{cyan}" >&2; fi
	print -n "changes=$COMPONENTS_STATS_CHANGES[$component]" >&2
	print -Pn "%f " >&2
	if test $COMPONENTS_STATS_CHANGES[$component] -lt 100; then print -n " " >&2; fi
	if test $COMPONENTS_STATS_CHANGES[$component] -lt 10;  then print -n " " >&2; fi
	# Warnings
	total_warnings=$((total_warnings + COMPONENTS_STATS_WARNINGS[$component]))
	if test $COMPONENTS_STATS_WARNINGS[$component] -gt 0; then print -Pn "%F{yellow}" >&2; fi
	print -n "warnings=$COMPONENTS_STATS_WARNINGS[$component]" >&2
	print -Pn "%f " >&2
	if test $COMPONENTS_STATS_WARNINGS[$component] -lt 100; then print -n " " >&2; fi
	if test $COMPONENTS_STATS_WARNINGS[$component] -lt 10;  then print -n " " >&2; fi
	# Errors
	total_errors=$((total_errors + COMPONENTS_STATS_ERRORS[$component]))
	if test $COMPONENTS_STATS_ERRORS[$component] -gt 0; then print -Pn "%F{red}" >&2; fi
	print -n "errors=$COMPONENTS_STATS_ERRORS[$component]" >&2
	print -P "%f" >&2
done

print >&2
print -Pn "%BTotals%b: " >&2
# OKs
if test $total_oks -gt 0; then print -Pn "%F{green}" >&2; fi
print -n "ok=$total_oks" >&2
print -Pn "%f   " >&2
# Changes
if test $total_changes -gt 0; then print -Pn "%F{cyan}" >&2; fi
print -n "changes=$total_changes" >&2
print -Pn "%f   " >&2
# Warnings
if test $total_warnings -gt 0; then print -Pn "%F{yellow}" >&2; fi
print -n "warnings=$total_warnings" >&2
print -Pn "%f   " >&2
# Errors
if test $total_errors -gt 0; then print -Pn "%F{red}" >&2; fi
print -n "errors=$total_errors" >&2
print -P "%f" >&2

if test $total_errors -gt 0; then exit 1;
else                              exit 0; fi
