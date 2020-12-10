#!/bin/zsh -euopipefail

# Install Frizlab’s conf
# Tested on macOS and Debian
# Usage: ./install [component ...]


################################
# Paths Setup and Verification #
################################

test "$(basename "$0")" = "install" || {
	echo "This script must be run from the install alias." >&2
	exit 1
}
cd "$(dirname "$0")"

# We export PATH in case the variable is not exported yet
export PATH

# We add our own bins to the path, but agree to use the system or user-defined
# ones if they are already there
path+="$(pwd)/.cache/bin"

# Let’s define the different paths we will need
readonly CACHE_FOLDER="$(pwd)/.cache"
readonly SRC_FOLDER="$(pwd)/src"
readonly LIB_FOLDER="$SRC_FOLDER/lib"
readonly COMPONENTS_FOLDER="$SRC_FOLDER/components"

# Create the cache folder if needed
mkdir -p "$CACHE_FOLDER" && chmod 700 "$CACHE_FOLDER"


###############
# Import libs #
###############

source "$LIB_FOLDER/facts.zsh"
source "$LIB_FOLDER/check-deps.zsh"
source "$LIB_FOLDER/catchout.zsh"
source "$LIB_FOLDER/ccrypt.zsh"
source "$LIB_FOLDER/group.zsh"
source "$LIB_FOLDER/logger.zsh"

source "$LIB_FOLDER/files.zsh"
source "$LIB_FOLDER/links.zsh"
source "$LIB_FOLDER/templates.zsh"

source "$SRC_FOLDER/vars.zsh"


##################
# Run components #
##################

# TODO: Select components from arguments
max_component_width=0
typeset -g CURRENT_TASK_NAME
for component in core dotfiles bin defaults; do
	test $max_component_width -lt $#component && max_component_width=$#component
	log_component_start "$component"
	pushd "$COMPONENTS_FOLDER/$component"
	source "./main.zsh"
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
	if test $COMPONENTS_STATS_OKS[$component] -lt 100; then print -n " "; fi
	if test $COMPONENTS_STATS_OKS[$component] -lt 10;  then print -n " "; fi
	# Changes
	total_changes=$((total_changes + COMPONENTS_STATS_CHANGES[$component]))
	if test $COMPONENTS_STATS_CHANGES[$component] -gt 0; then print -Pn "%F{cyan}" >&2; fi
	print -n "changes=$COMPONENTS_STATS_CHANGES[$component]" >&2
	print -Pn "%f " >&2
	if test $COMPONENTS_STATS_CHANGES[$component] -lt 100; then print -n " "; fi
	if test $COMPONENTS_STATS_CHANGES[$component] -lt 10;  then print -n " "; fi
	# Warnings
	total_warnings=$((total_warnings + COMPONENTS_STATS_WARNINGS[$component]))
	if test $COMPONENTS_STATS_WARNINGS[$component] -gt 0; then print -Pn "%F{yellow}" >&2; fi
	print -n "warnings=$COMPONENTS_STATS_WARNINGS[$component]" >&2
	print -Pn "%f " >&2
	if test $COMPONENTS_STATS_WARNINGS[$component] -lt 100; then print -n " "; fi
	if test $COMPONENTS_STATS_WARNINGS[$component] -lt 10;  then print -n " "; fi
	# Errors
	total_errors=$((total_errors + COMPONENTS_STATS_ERRORS[$component]))
	if test $COMPONENTS_STATS_ERRORS[$component] -gt 0; then print -Pn "%F{red}" >&2; fi
	print -n "errors=$COMPONENTS_STATS_ERRORS[$component]" >&2
	print -P "%f" >&2
done

print >&2
print -Pn "%F{magenta}%BTotals%b%f: " >&2
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
