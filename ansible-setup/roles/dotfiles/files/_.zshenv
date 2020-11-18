#!/bin/zsh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.

# Init file for ALL zsh shells. Including zsh from scripts! Called first.
# See https://github.com/Frizlab/frizlabs-conf for more info.

echo "ENTER: .zshenv" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"



################################################################################
echo "START: .zshenv" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# shellcheck source=/dev/null
# We import the .zshenv:dyn first because of the variables we could reuse
{ test -r "${HOME}/.zshenv:dyn" && source "${HOME}/.zshenv:dyn"; } || true



# TODO



### Let’s import .zshenv.d/*.sh files
for f in "${HOME}/.zshenv.d"/*.sh(N); do
	# shellcheck source=/dev/null
	{ test -r "$f" && source "$f"; } || true
done

################################################################################


echo "EXIT: .zshenv" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"
