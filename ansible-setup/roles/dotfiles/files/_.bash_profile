#!/bin/bash
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
echo "ENTER: .bash_profile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# Init file for login bash shell
# See https://github.com/Frizlab/frizlabs-conf for more info.


# shellcheck source=_.profile
# Let’s first include the standard non-bash specific profile
{ test -r "${HOME}/.profile" && source "${HOME}/.profile"; } || true

################################################################################
echo "START: .bash_profile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# shellcheck source=/dev/null
# We import the .bash_profile:dyn first because of the variables we could reuse
{ test -r "${HOME}/.bash_profile:dyn" && source "${HOME}/.bash_profile:dyn"; } || true


__show_branch1() {
	if git branch >/dev/null 2>&1; then printf "["; fi
}
export -f __show_branch1

__show_branch2() {
	# No need for more than 2 lines of status in theory as untracked are shown at the end
	status="$(git status -b --porcelain 2>/dev/null | head -n 3)"
	status_ret=${PIPESTATUS[0]}; # Not POSIX-sh compatible because of this f**er (PIPESTATUS)
	if [ "$status_ret" -ne 0 ]; then return; fi

	printf "%s" "$(echo "$status" | sed -En '/^## /s///p')"
	if   echo "$status" | grep -Eq '^[^#?]'; then printf '*'
	elif echo "$status" | grep -Eq '^\?';    then printf '~'
	fi
}
export -f __show_branch2

__show_branch3() {
	if git branch >/dev/null 2>&1; then printf "]"; fi
}
export -f __show_branch3

# \W: last path component
# You can comment the following lines to come back to the default prompt.
# IMPORTANT NOTE: The colors should be set directly within the variable, not
#                 from the output of the __show_branch* methods (which is why
#                 there are three methods)
export PS1='\[\033[01;36m\]\#\[\033[0m\] \\ \[\033[00;32m\]\t\[\033[0m\] / \[\033[00;33m\]\u@\h\[\033[0m\][\[\033[00;31m\]$?\[\033[0m\]] \[\033[01;38m\]\w\[\033[0m\]`__show_branch1`\[\033[00;31m\]`__show_branch2`\[\033[0m\]`__show_branch3`) '


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
# bash does not import automatically in a login shell
{ test -r "${HOME}/.bashrc" && source "${HOME}/.bashrc"; } || true

echo "EXIT: .bash_profile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"
