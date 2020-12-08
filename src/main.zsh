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

source "$LIB_FOLDER/recap.zsh"
