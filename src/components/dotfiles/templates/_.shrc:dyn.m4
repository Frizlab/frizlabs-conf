#!/bin/sh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/

########
# BREW #
########

m4_define(`m4_frz_brew_all',m4_dnl
brew-all() {
	local exit_code=0
	local first="true"
	for b in $1; do
		# What the lines below do is:
		# 0. Make sure the current brew exists,
		# 1. First declare a local variable whose name is the current brew ($b),
		#    but with _ instead of -, and the value is the alias’ content;
		# 2. Then check the binary the alias calls exists;
		# 3. And finally execute the alias with args given to brew-all.
		# Nah… it’s safe!
m4_dnl # Funny Story about the semicolon after the %s. Initially I wanted a comma, but m4 wasn’t happy (too many arguments to m4_define). I did not find a way to escape the comma…
		alias "$b" >/dev/null 2>&1 || { printf "\033[1;31mInvalid alias %s; please fix the “.shrc:dyn” file.\033[0m\n" "$b" >&2; continue; }
		eval "local $(alias "$b" | sed -E -e ':a' -e 's/^([^=]*)-/\1_/' -e 'ta')"
		local last_word=""; eval "for word in $(eval echo "\$$(echo "$b" | sed -E 's/-/_/g')"); do last_word=\"\$word\"; done"
		if [ -x "$last_word" ]; then
			if test "$first" != "true"; then printf "\n"; fi; first="false"
			printf "\033[1;35m%s %s\033[0m\n" "$b" "``$''*"
			if ! eval "eval \$$(echo "$b" | sed -E 's/-/_/g') \\\"\\\``$''@\\\""; then
				exit_code=1
			fi
		fi
	done
	return "$exit_code"
})m4_dnl
m4_dnl
m4_ifelse(___M4___DEFAULT_BREW_IS_SYSTEM___M4___, `false',
alias brew='brew-user'
alias brew-arm64='brew-user-arm64'
alias brew-x86='brew-user-x86'
,m4_dnl
alias brew='brew-system'
alias brew-arm64='brew-system-arm64'
alias brew-x86='brew-system-x86'
)m4_dnl
m4_dnl # These are the brew aliases, for the different arches.
m4_dnl # We only do this on macOS; for Linux we always use the “native” brew.
m4_ifelse(___M4___HOST_OS___M4___, `Darwin',m4_dnl
m4_ifelse(___M4___HOST_ARCH___M4___, `arm64',m4_dnl
alias   brew-user='brew-user-arm64'
alias brew-system='brew-system-arm64'
alias brew-user-arm64='HOMEBREW_CASK_OPTS="$HOMEBREW_CASK_OPTS '"___M4___FRZ_HOMEBREW_CASK_OPTS_USER___M4___"'"              "___M4___HOMEBREW_ARM64_USER_DIR___M4___/bin/brew"'
alias   brew-user-x86='HOMEBREW_CASK_OPTS="$HOMEBREW_CASK_OPTS '"___M4___FRZ_HOMEBREW_CASK_OPTS_USER___M4___"'" arch -x86_64 "___M4___HOMEBREW_X86_USER_DIR___M4___/bin/brew"'
alias brew-system-arm64='HOMEBREW_CASK_OPTS="$HOMEBREW_CASK_OPTS '"___M4___FRZ_HOMEBREW_CASK_OPTS_SYSTEM___M4___"'"              "___M4___HOMEBREW_ARM64_SYSTEM_DIR___M4___/bin/brew"'
alias   brew-system-x86='HOMEBREW_CASK_OPTS="$HOMEBREW_CASK_OPTS '"___M4___FRZ_HOMEBREW_CASK_OPTS_SYSTEM___M4___"'" arch -x86_64 "___M4___HOMEBREW_X86_SYSTEM_DIR___M4___/bin/brew"'

m4_frz_brew_all(brew-user-arm64 brew-user-x86 brew-system-arm64 brew-system-x86 brew-python39 brew-python38 brew-python37 brew-python27)
,m4_dnl
alias   brew-user='brew-user-x86'
alias brew-system='brew-system-x86'
alias   brew-user-x86='HOMEBREW_CASK_OPTS="$HOMEBREW_CASK_OPTS '"___M4___FRZ_HOMEBREW_CASK_OPTS_USER___M4___"'" "___M4___HOMEBREW_X86_USER_DIR___M4___/bin/brew"'
alias brew-user-arm64='echo "error: arm64 brew not available on this platform+arch" >&2; false'
alias   brew-system-x86='HOMEBREW_CASK_OPTS="$HOMEBREW_CASK_OPTS '"___M4___FRZ_HOMEBREW_CASK_OPTS_SYSTEM___M4___"'" "___M4___HOMEBREW_X86_SYSTEM_DIR___M4___/bin/brew"'
alias brew-system-arm64='echo "error: arm64 brew not available on this platform+arch" >&2; false'

m4_frz_brew_all(brew-user-x86 brew-system-x86 brew-python39 brew-python38 brew-python37 brew-python27)
))m4_dnl
