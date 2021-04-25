# Gather some facts

HOST_OS="$(uname -s)";   typeset -r HOST_OS
HOST_ARCH="$(uname -m)"; typeset -r HOST_ARCH

USER_ID=$(id -u); typeset -r CURRENT_USER_ID

TERM_WIDTH="$(tput cols)"; typeset -r TERM_WIDTH
