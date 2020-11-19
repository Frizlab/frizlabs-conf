#!/bin/zsh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.

# Init file for interactive zsh shell.
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



# PS1, see bashrc for more info
__show_branch1() {
	if git branch >/dev/null 2>&1; then printf "["; fi
}
__show_branch2() {
	# No need for more than 2 lines of status in theory as untracked are shown at the end
	git_status="$(git status -b --porcelain 2>/dev/null | head -n 3)"
	git_status_ret=${PIPESTATUS[0]}; # Not POSIX-sh compatible because of this f**er (PIPESTATUS)
	if [ "$git_status_ret" -ne 0 ]; then return; fi

	printf "%s" "$(echo "$git_status" | sed -En '/^## /s///p')"
	if   echo "$git_status" | grep -Eq '^[^#?]'; then printf '*'
	elif echo "$git_status" | grep -Eq '^\?';    then printf '~'
	fi
}
__show_branch3() {
	if git branch >/dev/null 2>&1; then printf "]"; fi
}
# We have to enable prompt substitutions for the git functions to work
# We also set transientrprompt to remove RPS1 when the command has been accepted
setopt PROMPT_SUBST transientrprompt
# Note: There is probably a better way to handle the git prompt. I don’t care.
# \e is the same as \033. We could probably use %F and %B and co instead, but I
# did not found the same colors I was used to fast enough, and found the %{%}
# solution to have the RPS1 correctly placed, so I did not search further.
PS1=$'%{\e[01;36m%}%i%{\e[0m%} \\ %{\e[00;32m%}%*%{\e[0m%} / %{\e[00;33m%}%n@%m%{\e[0m%}[%{\e[00;31m%}%?%{\e[0m%}] %{\e[01;38m%}%~%{\e[0m%}`__show_branch1`%{\e[00;31m%}`__show_branch2`%{\e[0m%}`__show_branch3`) '
RPS1='🤠🙃😃'; # Just to remember we’re using zsh



### Let’s import .zshrc.d/*.sh files
for f in "${HOME}/.zshrc.d"/*.sh(N); do
	# shellcheck source=/dev/null
	{ test -r "$f" && source "$f"; } || true
done

################################################################################


echo "EXIT: .zshrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"
