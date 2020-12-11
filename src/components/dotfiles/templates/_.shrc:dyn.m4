#!/bin/sh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
m4_ifelse(___M4___HOST_OS___M4___:___M4___HOST_ARCH___M4___, `Darwin:arm64',m4_dnl

alias brew-x86="arch -x86_64 ___M4___HOMEBREW_X86_DIR___M4___/bin/brew"
)m4_dnl
