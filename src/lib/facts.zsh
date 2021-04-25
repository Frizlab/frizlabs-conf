# Gather some facts

HOST_OS="$(uname -s)";   readonly HOST_OS
HOST_ARCH="$(uname -m)"; readonly HOST_ARCH

USER_ID=$(id -u); readonly CURRENT_USER_ID

# Note: “typeset -r” is strictly equivalent (AFAICT) to “readonly”.
# We kept one “typeset -r” as a kind of documentation for the future.
TERM_WIDTH="$(tput cols)"; typeset -r TERM_WIDTH
