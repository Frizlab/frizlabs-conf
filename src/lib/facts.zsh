# Note: We assume none of the binaries call will fail in this script

readonly HOST_OS="$(uname -s)"
readonly HOST_ARCH="$(uname -m)"

readonly TERM_WIDTH="$(tput cols)"
