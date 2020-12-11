#!/bin/sh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/

# brew aliases
alias brew='___M4___HOMEBREW_DIR___M4___/bin/brew'
m4_dnl # These are the brew aliases, for the different arches.
m4_dnl # We only do this on macOS; for Linux we always use the “native” brew.
m4_ifelse(___M4___HOST_OS___M4___, `Darwin',m4_dnl
m4_ifelse(___M4___HOST_ARCH___M4___, `arm64',m4_dnl
alias brew-x86='arch -x86_64 ___M4___HOMEBREW_X86_DIR___M4___/bin/brew'
alias brew-arm64='brew',
m4_dnl
alias brew-x86='brew'
alias brew-arm64='echo "error: arm64 brew not available on this platform+arch" >&2; false'
))

m4_dnl # TODO: All of these aliases using m4
m4_dnl
# python3.9 aliases (first is a brew one, to update said python)
alias brew-python3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/brew'
alias 2to3-3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/2to3-3.9'
alias easy_install-3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/easy_install-3.9'
alias idle3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/idle3.9'
alias pip3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/python3.9'
alias pydoc3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/pydoc3.9'
alias python3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/python3.9'
alias python3.9-config='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/python3.9-config'

# python3.8 aliases (first is a brew one, to update said python)
#alias brew-python3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/brew'
#alias 2to3-3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/2to3-3.9'
#alias easy_install-3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/easy_install-3.9'
#alias idle3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/idle3.9'
#alias pip3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/python3.9'
#alias pydoc3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/pydoc3.9'
#alias python3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/python3.9'
#alias python3.9-config='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/python3.9-config'

# python3.7 aliases (first is a brew one, to update said python)
#alias brew-python3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/brew'
#alias 2to3-3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/2to3-3.9'
#alias easy_install-3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/easy_install-3.9'
#alias idle3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/idle3.9'
#alias pip3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/python3.9'
#alias pydoc3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/pydoc3.9'
#alias python3.9='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/python3.9'
#alias python3.9-config='___M4___HOMEBREW_PYTHON39_DIR___M4___/bin/python3.9-config'

# We set current python to 3.9
alias brew='brew-python3.9'
alias 2to3='2to3-3.9'
alias easy_install='easy_install-3.9'
alias idle='idle3.9'
alias pip='pip3.9'
alias pydoc='pydoc3.9'
alias python='python3.9'
alias python-config='python3.9-config'

alias pip39-upgrade-all='pip3.9 list --outdated --format=freeze | grep -v -e wheel -e pip -e setuptools | cut -d= -f1 | xargs pip3.9 install --upgrade'
#alias pip38-upgrade-all='pip3.8 list --outdated --format=freeze | grep -v -e wheel -e pip -e setuptools | cut -d= -f1 | xargs pip3.8 install --upgrade'
#alias pip37-upgrade-all='pip3.7 list --outdated --format=freeze | grep -v -e wheel -e pip -e setuptools | cut -d= -f1 | xargs pip3.7 install --upgrade'
# When possible again, use commented line below
alias pip-upgrade-all='pip39-upgrade-all'
#alias pip-upgrade-all='pip39-upgrade-all; pip38-upgrade-all; pip37-upgrade-all'
