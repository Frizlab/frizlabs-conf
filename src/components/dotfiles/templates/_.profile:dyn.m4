#!/bin/sh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/

# The Homebrew prefix. Mostly used by the conf scripts.
export FRZ_HOMEBREW_PREFIX="___M4___HOMEBREW_NATIVE_USER_DIR___M4___"

# The Homebrew for Python 3.9 prefix. Only Python 3.9 should be installed in this prefix.
export FRZ_HOMEBREW_PYTHON39_PREFIX="___M4___HOMEBREW_PYTHON39_USER_DIR___M4___"

# Homebrew GitHub API token. Homebrew does some requests to GitHub’s API; giving
# it a token will allow for more requests to GitHub.
export HOMEBREW_GITHUB_API_TOKEN="___M4___HOMEBREW_GITHUB_TOKEN___M4___"
m4_ifelse(___M4___DARK_MODE___M4___, `true',m4_dnl

# Dark mode support for ls
export LSCOLORS=GxFxCxDxBxegedabagaced
)m4_dnl
