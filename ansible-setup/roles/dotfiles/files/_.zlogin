#!/bin/zsh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.

# Init file for login zsh shell, after the zshrc has loaded.
# See https://github.com/Frizlab/frizlabs-conf for more info.

echo "ENTER: .zlogin" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"



################################################################################
echo "START: .zlogin" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# shellcheck source=/dev/null
# We import the .zlogin:dyn first because of the variables we could reuse
{ test -r "${HOME}/.zlogin:dyn" && source "${HOME}/.zlogin:dyn"; } || true



# TODO



### Let’s import .zlogin.d/*.sh files
for f in "${HOME}/.zlogin.d"/*.sh(N); do
	# shellcheck source=/dev/null
	{ test -r "$f" && source "$f"; } || true
done

################################################################################


echo "EXIT: .zlogin" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"
