#!/bin/sh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/

# PATH Management
export PATH="___M4___HOMEBREW_PREFIX___M4___/opt/ruby/bin:${PATH}"; # We force using Homebrew’s ruby because the system’s is old and some gems fail to install/update
export PATH="___M4___HOMEBREW_PYTHON39_PREFIX___M4___/bin:${PATH}"; # We force using Homebrew’s Python3.9…
export PATH="___M4___HOMEBREW_PYTHON39_PREFIX___M4___/opt/python@3.9/libexec/bin:${PATH}"; # And Python3 when using an unversioned “python”
export PATH="${PATH}:/usr/local/sbin"
export PATH="${PATH}:${HOME}/usr/bin"
export PATH="${PATH}:${FRZ_HOMEBREW_PREFIX}/bin"
export PATH="${PATH}:${HOME}/usr/cappuccino/bin"
#export PATH="${PATH}:${HOME}/Library/Python/*/bin"; # For system Python when installing in user path
export PATH="${PATH}:${HOME}/usr/ruby/bin"
export PATH="${PATH}:${HOME}/usr/npm/bin"
export PATH="${PATH}:${HOME}/usr/go/bin"
export PATH="${PATH}:${HOME}/.krew/bin"
export PATH="${PATH}:."

# Compilation options management for custom install brew
export LDFLAGS="${LDFLAGS} -L${FRZ_HOMEBREW_PREFIX}/lib"
export CFLAGS="${CFLAGS} -I${FRZ_HOMEBREW_PREFIX}/include"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${FRZ_HOMEBREW_PREFIX}/lib/pkgconfig"

# Python
# --> We use the brewed Python. Nothing fancy to do for Python!
#     Eggs are installed in homebrew prefix with pip2 or pip3.

# Ruby
export GEM_HOME="${HOME}/usr/ruby"

# Cappuccino
export NARWHAL_ENGINE=jsc
export CAPP_BUILD="${HOME}/Library/Caches/Cappuccino/DerivedData"

# NPM
export NPM_CONFIG_PREFIX="${HOME}/usr/npm"

# Go
export GOPATH="${HOME}/usr/go"


# Homebrew GitHub API token. Homebrew does some requests to GitHub’s API; giving
# it a token will allow for more requests to GitHub.
export HOMEBREW_GITHUB_API_TOKEN="___M4___HOMEBREW_GITHUB_TOKEN___M4___"
m4_ifelse(___M4___DARK_MODE___M4___, `true',m4_dnl

# Dark mode support for ls
export LSCOLORS=GxFxCxDxBxegedabagaced
)m4_dnl
