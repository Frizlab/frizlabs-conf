#!/bin/zsh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
echo "ENTER: .zprofile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# Init file for login zsh shell
# See https://github.com/Frizlab/frizlabs-conf for more info.


# shellcheck source=_.profile
# Let’s first include the standard non-zsh specific profile. We disable the
# nomatch option for the time of the import because zsh does not behave the same
# as (ba)sh, and fails when the glob does not match anything. There might me
# more options to disable later.
{ test -r "${HOME}/.profile" && (){ setopt localoptions; unsetopt nomatch; source "${HOME}/.profile"; }; } || true

################################################################################
echo "START: .zprofile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# shellcheck source=/dev/null
# We import the .zprofile:dyn first because of the variables we could reuse
{ test -r "${HOME}/.zprofile:dyn" && source "${HOME}/.zprofile:dyn"; } || true



# TODO



### Let’s import .zprofile.d/*.sh files
for f in "${HOME}/.zprofile.d"/*.sh(N); do
	# shellcheck source=/dev/null
	{ test -r "$f" && source "$f"; } || true
done

################################################################################

# Note: zsh does load the zshrc even in a login shell (w/ bash we had to force
#       the import of the bashrc file)

echo "EXIT: .zprofile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"
