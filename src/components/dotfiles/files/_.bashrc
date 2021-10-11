#!/bin/bash
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.

# Init file for interactive bash shell.
# See https://github.com/Frizlab/frizlabs-conf for more info.

echo "ENTER: .bashrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"


# shellcheck source=_.shrc
# Let’s first include the non-standard non-bash specific rc file
{ test -r "${HOME}/.shrc" && source "${HOME}/.shrc"; } || true


################################################################################
echo "START: .bashrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# shellcheck source=/dev/null
# We import the .bashrc:dyn first because of the variables we could reuse
{ test -r "${HOME}/.bashrc:dyn" && source "${HOME}/.bashrc:dyn"; } || true



# PS1
__show_branch1() {
	if git branch >/dev/null 2>&1; then printf "["; fi
}
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
__show_branch3() {
	if git branch >/dev/null 2>&1; then printf "]"; fi
}
# \W: last path component
# NOTE: Unlike my zsh PS1, my bash PS1 does not support iCloud checks for git.
# Dev note: The colors should be set directly within the variable, not from the
#           output of the __show_branch* methods (which is why there are three
#           methods instead of just one).
# We used to set this in the bash_profile because it’s a variable that can be
# exported and does not need to be reloaded for the children (was defined as
# `export PS1=`). However, this variable is only needed for interactive shells,
# not login ones, and children of the shell definitely do not need to know about
# my PS1, so we moved it here.
PS1='\[\033[01;36m\]\#\[\033[0m\] \\ \[\033[00;32m\]\t\[\033[0m\] / \[\033[00;33m\]\u@\h\[\033[0m\][\[\033[00;31m\]$?\[\033[0m\]] \[\033[01;38m\]\w\[\033[0m\]`__show_branch1`\[\033[00;31m\]`__show_branch2`\[\033[0m\]`__show_branch3`) '
# - We may want to set PS2 too. It sets the prompt shown after a return when the
#   command line is not finished.
# - If we ever wanted to set PROMPT_COMMAND (we don’t need it now but why not),
#   we should be careful and keep the previous PROMPT_COMMAND value:
#      PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }new_code_here"
#   See /etc/bashrc_Apple_Terminal for some additional info.
#   Some light info on this var: https://stackoverflow.com/a/3058366

# Bash specific alias
alias h='cat ~/.bash_sessions/*.history*'

# Homebrew - TODO: Verify FRZ_HOMEBREW_PREFIX is set in all cases
# shellcheck source=/dev/null
for f in "${FRZ_HOMEBREW_PREFIX}/etc/bash_completion.d"/*; do { test -f "$f" && source "$f"; } || true; done



### Let’s import .bashrc.d/*.sh files
for f in "${HOME}/.bashrc.d"/*.sh; do
	# shellcheck source=/dev/null
	{ test -r "$f" && source "$f"; } || true
done

################################################################################


echo "EXIT: .bashrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"
