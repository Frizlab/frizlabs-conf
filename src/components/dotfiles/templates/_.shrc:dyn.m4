#!/bin/sh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/

# brew aliases
m4_ifelse(___M4___DEFAULT_BREW_IS_SYSTEM___M4___, `false',
alias brew='brew-user'
alias brew-arm64='brew-user-arm64'
alias brew-x86='brew-user-x86'
,m4_dnl
alias brew='brew-system'
alias brew-arm64='brew-system-arm64'
alias brew-x86='brew-system-x86'
)m4_dnl
alias brew-user='___M4___HOMEBREW_USER_DIR___M4___/bin/brew'
alias brew-system='___M4___HOMEBREW_SYSTEM_DIR___M4___/bin/brew'
m4_dnl # These are the brew aliases, for the different arches.
m4_dnl # We only do this on macOS; for Linux we always use the “native” brew.
m4_ifelse(___M4___HOST_OS___M4___, `Darwin',m4_dnl
m4_ifelse(___M4___HOST_ARCH___M4___, `arm64',m4_dnl
alias brew-user-arm64='___M4___HOMEBREW_ARM64_USER_DIR___M4___/bin/brew'
alias brew-user-x86='arch -x86_64 ___M4___HOMEBREW_X86_USER_DIR___M4___/bin/brew'
alias brew-system-arm64='___M4___HOMEBREW_ARM64_SYSTEM_DIR___M4___/bin/brew'
alias brew-system-x86='arch -x86_64 ___M4___HOMEBREW_X86_SYSTEM_DIR___M4___/bin/brew'
,m4_dnl
alias brew-user-x86='___M4___HOMEBREW_X86_USER_DIR___M4___/bin/brew'
alias brew-user-arm64='echo "error: arm64 brew not available on this platform+arch" >&2; false'
alias brew-system-x86='___M4___HOMEBREW_X86_SYSTEM_DIR___M4___/bin/brew'
alias brew-system-arm64='echo "error: arm64 brew not available on this platform+arch" >&2; false'
))m4_dnl
