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
source "$LIB_FOLDER/ccrypt.zsh"
source "$LIB_FOLDER/group.zsh"
source "$LIB_FOLDER/logger.zsh"

source "$SRC_FOLDER/vars.zsh"


##################
# Run components #
##################

# TODO: Select components from arguments
typeset -g CURRENT_TASK_NAME
log_component_start core
pushd "$COMPONENTS_FOLDER/core"
source "./main.zsh"
popd
log_component_end


#########
# Recap #
#########

log_line "Installations recap" ""

typeset -g total_errors=0
typeset -g total_warnings=0
typeset -g total_successes=0
for component in ${(k)COMPONENTS_STATS_SUCCESSES}; do
	print -Pn "%B$component%b: "
	# Successes
	total_successes=$((total_successes + COMPONENTS_STATS_SUCCESSES[$component]))
	if test $COMPONENTS_STATS_SUCCESSES[$component] -gt 0; then print -Pn "%F{green}"; fi
	print -n "ok=$COMPONENTS_STATS_SUCCESSES[$component]"
	print -Pn "%f   "
	# Warnings
	total_warnings=$((total_warnings + COMPONENTS_STATS_WARNINGS[$component]))
	if test $COMPONENTS_STATS_WARNINGS[$component] -gt 0; then print -Pn "%F{yellow}"; fi
	print -n "warnings=$COMPONENTS_STATS_WARNINGS[$component]"
	print -Pn "%f   "
	# Errors
	total_errors=$((total_errors + COMPONENTS_STATS_ERRORS[$component]))
	if test $COMPONENTS_STATS_ERRORS[$component] -gt 0; then print -Pn "%F{red}"; fi
	print -n "errors=$COMPONENTS_STATS_ERRORS[$component]"
	print -P "%f"
done

print
print -Pn "%F{magenta}%BTotals%b%f: "
# Successes
if test $total_successes -gt 0; then print -Pn "%F{green}"; fi
print -n "ok=$total_successes"
print -Pn "%f   "
# Warnings
total_warnings=$((total_warnings + COMPONENTS_STATS_WARNINGS[component]))
if test $total_warnings -gt 0; then print -Pn "%F{yellow}"; fi
print -n "warnings=$total_warnings"
print -Pn "%f   "
# Errors
total_errors=$((total_errors + COMPONENTS_STATS_ERRORS[component]))
if test $total_errors -gt 0; then print -Pn "%F{red}"; fi
print -n "errors=$total_errors"
print -P "%f"
