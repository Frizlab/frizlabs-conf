#!/bin/sh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
m4_changecom(`m4_#')m4_dnl

m4_dnl # User Homebrew PATH updates
m4_define(`m4_frz_brew_user_path_update',m4_dnl
PATH="${PATH}:___M4___HOMEBREW_USER_DIR___M4___/bin"
PATH="${PATH}:___M4___HOMEBREW_USER_DIR___M4___/sbin"
m4_ifelse(___M4___HOST_OS___M4___:___M4___HOST_ARCH___M4___, `Darwin:arm64',
PATH="${PATH}:___M4___HOMEBREW_X86_USER_DIR___M4___/bin"
PATH="${PATH}:___M4___HOMEBREW_X86_USER_DIR___M4___/sbin"
)m4_dnl
)m4_dnl
m4_dnl # System Homebrew PATH updates
m4_define(`m4_frz_brew_system_path_update',m4_dnl
PATH="${PATH}:___M4___HOMEBREW_SYSTEM_DIR___M4___/bin"
PATH="${PATH}:___M4___HOMEBREW_SYSTEM_DIR___M4___/sbin"
m4_ifelse(___M4___HOST_OS___M4___:___M4___HOST_ARCH___M4___, `Darwin:arm64',
# We do not install the system x86 Homebrew on ARM macOS anymore```,''' so these two lines are commented.
#PATH="${PATH}:___M4___HOMEBREW_X86_SYSTEM_DIR___M4___/bin"
#PATH="${PATH}:___M4___HOMEBREW_X86_SYSTEM_DIR___M4___/sbin"
)m4_dnl
)m4_dnl

### PATH Management ###

# Default PATH is (or was, when checked): /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin
# We remove /usr/local/bin; we’ll add it later, _after_ /usr/bin & co
PATH="$(echo "$PATH" | sed -Ee 's|:?/usr/local/bin:?||')"

# We force the brew installation of the following binaries:
#    - rsync: System’s rsync is OpenRSync;
#    - ruby: System’s ruby is old and some gems fail to install/update;
#    - python: System’s python3 might be ok, but I’ve learned not to rely on system binaries (we have no guarantees; they are installed because the system needs them).
#              IMPORTANT: “pip3 install” will install in the system brew prefix folder. Use “pip3 install --user” to install in ~/clt/envs/python3.
#    - tcl/tk: System’s tcl/tk is deprecated (warning on stderr on launch).
#    - bash: System’s bash is old. Very old.
# So the paths to the parent folder of these binaries will be first in the path.
PATH="___M4___HOMEBREW_SYSTEM_DIR___M4___/opt/python3/bin:${PATH}"
PATH="___M4___HOMEBREW_SYSTEM_DIR___M4___/opt/ruby/bin:${PATH}"
PATH="___M4___HOMEBREW_SYSTEM_DIR___M4___/opt/rsync/bin:${PATH}"
PATH="___M4___HOMEBREW_SYSTEM_DIR___M4___/opt/tcl-tk/bin:${PATH}"
PATH="___M4___HOMEBREW_SYSTEM_DIR___M4___/opt/bash/bin:${PATH}"

# We want to use the system binaries as much as possible.
# So we do not put anything else than the override above in front of the PATH.

# Above all, after the system, the 1st and 3rd party bin folders win.
PATH="${PATH}:___M4___FIRST_PARTY_BIN_DIR___M4___"
PATH="${PATH}:___M4___THIRD_PARTY_BIN_DIR___M4___"

m4_dnl # Note: There are aliases in the shrc to select brew, but we want the PATH to be correct too (mainly for the scripts).
m4_dnl #       So we check whether the default brew is the system one and act accordingly.
# After those there are the Homebrews PATHs.
m4_ifelse(___M4___DEFAULT_BREW_IS_SYSTEM___M4___, `false',
# First the user Homebrew as it is the default one.
m4_frz_brew_user_path_update()m4_dnl
# Then the system Homebrew.
m4_frz_brew_system_path_update()m4_dnl
,m4_dnl
# First the system Homebrew as it is the default one.
m4_frz_brew_system_path_update()m4_dnl
# Then the user Homebrew.
m4_frz_brew_user_path_update()m4_dnl
)m4_dnl

# After Homebrew we add /usr/local bin and sbin.
# Note: These might have already been added with the system Homebrew (above).
PATH="${PATH}:/usr/local/bin"
PATH="${PATH}:/usr/local/sbin"

# Then, we allow (or not) some bins from some envs.
PATH="${PATH}:___M4___CAPPUCCINO_DIR___M4___/bin"
#PATH="${PATH}:___M4___RUBY_DIR___M4___/bin"
#PATH="${PATH}:___M4___NPM_DIR___M4___/bin"
#PATH="${PATH}:___M4___GO_DIR___M4___/bin"
#PATH="${PATH}:${HOME}/.krew/bin"

# Finally, we also check cwd.
PATH="${PATH}:."

# Export PATH in case it was not exported.
export PATH

# We do _not_ set PKG_CONFIG_PATH & co by design to be closer to a pristine macOS install by default.

# Python
# This forces USER installs from pip to go to this folder. Not non-user installs.
# We have hidden pip3 behind an alias to check installs are done as user installs.
# Fuck pip. Again and more.
export PYTHONUSERBASE="___M4___PYTHON_DIR___M4___"

# Ruby
export GEM_HOME="___M4___RUBY_DIR___M4___"

# Cappuccino
export NARWHAL_ENGINE=jsc
export CAPP_BUILD="${HOME}/Library/Caches/Cappuccino/DerivedData"

# NPM
export NPM_CONFIG_PREFIX="___M4___NPM_DIR___M4___"

# Go
export GOPATH="___M4___GO_DIR___M4___"


# Homebrew GitHub API token.
# Homebrew does some requests to GitHub’s API; giving it a token will allow for more requests to GitHub.
export HOMEBREW_GITHUB_API_TOKEN="___M4___DOTFILES__HOMEBREW_GITHUB_TOKEN___M4___"
# The appdir and other dirs are chosen through brew aliases. See shrc:dyn.
export HOMEBREW_CASK_OPTS="___M4___FRZ_HOMEBREW_CASK_OPTS_BASE___M4___"
m4_ifelse(___M4___DARK_MODE___M4___, `true',m4_dnl

# Dark mode support for ls
export LSCOLORS=GxFxCxDxBxegedabagaced
)m4_dnl
