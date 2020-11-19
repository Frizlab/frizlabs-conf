#!/bin/zsh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.

# Init file for non-login interactive zsh shell.
# See https://github.com/Frizlab/frizlabs-conf for more info.

echo "ENTER: .zshrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"


# shellcheck source=_.shrc
# Let’s first include the non-standard non-zsh specific rc file. We disable the
# nomatch option for the time of the import because zsh does not behave the same
# as (ba)sh, and fails when the glob does not match anything. There might me
# more options to disable later.
{ test -r "${HOME}/.shrc" && (){ setopt localoptions; unsetopt nomatch; source "${HOME}/.shrc"; }; } || true


################################################################################
echo "START: .zshrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# shellcheck source=/dev/null
# We import the .zshrc:dyn first because of the variables we could reuse
{ test -r "${HOME}/.zshrc:dyn" && source "${HOME}/.zshrc:dyn"; } || true



# TODO



### Let’s import .zshrc.d/*.sh files
for f in "${HOME}/.zshrc.d"/*.sh(N); do
	# shellcheck source=/dev/null
	{ test -r "$f" && source "$f"; } || true
done

################################################################################


echo "EXIT: .zshrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"
