#!/bin/bash
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.

# Init file for login bash shell.
# See https://github.com/Frizlab/frizlabs-conf for more info.

echo "ENTER: .bash_profile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"


# shellcheck source=_.profile
# Let’s first include the standard non-bash specific profile
{ test -r "${HOME}/.profile" && source "${HOME}/.profile"; } || true


################################################################################
echo "START: .bash_profile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# shellcheck source=/dev/null
# We import the .bash_profile:dyn first because of the variables we could reuse
{ test -r "${HOME}/.bash_profile:dyn" && source "${HOME}/.bash_profile:dyn"; } || true



# Bash history control. Set to ignore duplicates in
# history, as well as lines starting with a space
# Note: An alias for this is ignoreboth
# Note2: Technically this is POSIX-compliant (this is after all simply an export
#        of a variable) but as it is only useful for bash, we keep it here.
export HISTCONTROL=ignoredups:ignorespace

# !12 will retype command #12, NOT reexecute it without asking
shopt -s histverify

# Allow one-off typing errors
# https://www.gnu.org/software/bash/manual/bashref.html#The-Set-Builtin
shopt -s cdspell



### Let’s import .bash_profile.d/*.sh files
for f in "${HOME}/.bash_profile.d"/*.sh; do
	# shellcheck source=/dev/null
	{ test -r "$f" && source "$f"; } || true
done

################################################################################


# shellcheck source=_.bashrc
# Now we’ve done anything login-specific, we import the non-login rc file, which
# bash does not import automatically in a login shell.
{ test -r "${HOME}/.bashrc" && source "${HOME}/.bashrc"; } || true


echo "EXIT: .bash_profile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"
