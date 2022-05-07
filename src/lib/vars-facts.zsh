# Gather some facts.

HOST_OS="$(uname -s)";   readonly HOST_OS
HOST_ARCH="$(uname -m)"; readonly HOST_ARCH

# Note: “typeset -r” is strictly equivalent (AFAICT) to “readonly”.
# We kept one “typeset -r” as a kind of documentation for the future.
USER_ID=$(id -u); typeset -r CURRENT_USER_ID

# tput can fail if there are no tty (e.g. in a docker build context), hence the “|| print 0”.
TERM_WIDTH="$(tput cols 2>/dev/null || print 0)"; readonly TERM_WIDTH
