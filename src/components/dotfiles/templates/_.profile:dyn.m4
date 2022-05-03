#!/bin/sh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
m4_changecom(`m4_#')m4_dnl


### PATH Management ###

# Default PATH is (or was, when checked): /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin
# We remove /usr/local/bin; we’ll add it later, _after_ /usr/bin & co
PATH="$(echo "$PATH" | sed -Ee 's|:?/usr/local/bin:?||')"

# We force the brew installation of the following binaries:
#    - rsync: system’s rsync is very old;
#    - ruby: system’s ruby is old and some gems fail to install/update;
#    - python: system’s python3 might be ok, but I’ve learned not to rely on system binaries (we have no guarantees; they are installed because the system needs them).
#              IMPORTANT: “pip3 install” will install in the system brew prefix folder. Use “pip3 install --user” to install in ~/clt/python3.
# So the paths to the parent folder of these binaries will be first in the path.
PATH="___M4___HOMEBREW_SYSTEM_DIR___M4___/opt/python3/bin:${PATH}"
PATH="___M4___HOMEBREW_SYSTEM_DIR___M4___/opt/ruby/bin:${PATH}"
PATH="___M4___HOMEBREW_SYSTEM_DIR___M4___/opt/rsync/bin:${PATH}"

# Next we want to use the system binaries as much as possible.
# So we do not put anything else than the override above in front of the PATH.
# Above all, the 1st and 3rd party bin folders win.
PATH="${PATH}:___M4___FIRST_PARTY_BIN_DIR___M4___"
PATH="${PATH}:___M4___THIRD_PARTY_BIN_DIR___M4___"
# Then the user homebrew(s) – WHICH MEANS THE DEFAULT HOMEBREW IS THE USER ONE WHEN USING THE PATH RESOLUTION!
# There are aliases in the shrc to select brew.
PATH="${PATH}:___M4___HOMEBREW_USER_DIR___M4___/bin"
PATH="${PATH}:___M4___HOMEBREW_USER_DIR___M4___/sbin"
m4_ifelse(___M4___HOST_OS___M4___:___M4___HOST_ARCH___M4___, `Darwin:arm64',m4_dnl
PATH="${PATH}:___M4___HOMEBREW_X86_USER_DIR___M4___/bin"
PATH="${PATH}:___M4___HOMEBREW_X86_USER_DIR___M4___/sbin"
)m4_dnl
# Then the system homebrew(s)
PATH="${PATH}:___M4___HOMEBREW_SYSTEM_DIR___M4___/bin"
PATH="${PATH}:___M4___HOMEBREW_SYSTEM_DIR___M4___/sbin"
m4_ifelse(___M4___HOST_OS___M4___:___M4___HOST_ARCH___M4___, `Darwin:arm64',m4_dnl
PATH="${PATH}:___M4___HOMEBREW_X86_SYSTEM_DIR___M4___/bin"
PATH="${PATH}:___M4___HOMEBREW_X86_SYSTEM_DIR___M4___/sbin"
)m4_dnl
# After that we add /usr/local bin and sbin.
# Note: they are probably already added with the system homebrew.
PATH="${PATH}:/usr/local/bin"
PATH="${PATH}:/usr/local/sbin"
PATH="${PATH}:___M4___CLT_DIR___M4___/cappuccino/bin"
#PATH="${PATH}:___M4___CLT_DIR___M4___/ruby/bin"
#PATH="${PATH}:___M4___CLT_DIR___M4___/npm/bin"
#PATH="${PATH}:___M4___CLT_DIR___M4___/go/bin"
#PATH="${PATH}:${HOME}/.krew/bin"
PATH="${PATH}:."

# Export PATH in case it was not exported.
export PATH

# We do _not_ set PKG_CONFIG_PATH & co by design to be closer to a pristine macOS install by default.

# Python
# This forces USER installs from pip to go to this folder. Not non-user installs.
# We have hidden pip3 behind an alias to check installs are done as user installs.
# Fuck pip. Again and more.
export PYTHONUSERBASE="___M4___CLT_DIR___M4___/python3"

# Ruby
export GEM_HOME="___M4___CLT_DIR___M4___/ruby"

# Cappuccino
export NARWHAL_ENGINE=jsc
export CAPP_BUILD="${HOME}/Library/Caches/Cappuccino/DerivedData"

# NPM
export NPM_CONFIG_PREFIX="___M4___CLT_DIR___M4___/npm"

# Go
export GOPATH="___M4___CLT_DIR___M4___/go"


# Homebrew GitHub API token.
# Homebrew does some requests to GitHub’s API; giving it a token will allow for more requests to GitHub.
export HOMEBREW_GITHUB_API_TOKEN="___M4___DOTFILES__HOMEBREW_GITHUB_TOKEN___M4___"
# The appdir and other dirs are chosen through brew aliases. See shrc:dyn.
export HOMEBREW_CASK_OPTS="___M4___FRZ_HOMEBREW_CASK_OPTS_BASE___M4___"
m4_ifelse(___M4___DARK_MODE___M4___, `true',m4_dnl

# Dark mode support for ls
export LSCOLORS=GxFxCxDxBxegedabagaced
)m4_dnl
