#!/bin/sh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/

# brew aliases
alias brew='___M4___HOMEBREW_NATIVE_USER_DIR___M4___/bin/brew'
m4_dnl # These are the brew aliases, for the different arches.
m4_dnl # We only do this on macOS; for Linux we always use the “native” brew.
m4_ifelse(___M4___HOST_OS___M4___, `Darwin',m4_dnl
m4_ifelse(___M4___HOST_ARCH___M4___, `arm64',m4_dnl
alias brew-x86='arch -x86_64 ___M4___HOMEBREW_X86_USER_DIR___M4___/bin/brew'
alias brew-arm64='brew',
m4_dnl
alias brew-x86='brew'
alias brew-arm64='echo "error: arm64 brew not available on this platform+arch" >&2; false'
))

m4_define(`frzm4_python_def',
# python$2 aliases (first is a brew one, to update said python)
$3alias brew-python$2='$1/bin/brew'
$3alias 2to3-$2='$1/bin/2to3-$2'
$3alias easy_install-$2='$1/bin/easy_install-$2'
$3alias idle$2='$1/bin/idle$2'
$3alias pip$2='$1/bin/python$2'
$3alias pydoc$2='$1/bin/pydoc$2'
$3alias python$2='$1/bin/python$2'
$3alias python$2-config='$1/bin/python$2-config'
)m4_dnl
m4_dnl
frzm4_python_def(___M4___HOMEBREW_PYTHON39_USER_DIR___M4___, 3.9)
m4_dnl # Python 3.8, 3.7 and 2.7 disabled because do not compile on macOS Big Sur
frzm4_python_def(___M4___HOMEBREW_PYTHON38_USER_DIR___M4___, 3.8, `#')
frzm4_python_def(___M4___HOMEBREW_PYTHON37_USER_DIR___M4___, 3.7, `#')
frzm4_python_def(___M4___HOMEBREW_PYTHON27_USER_DIR___M4___, 2.7, `#')
m4_dnl
# More Python aliases (upgrade all pip eggs)
alias pip39-upgrade-all='pip3.9 list --outdated --format=freeze | grep -v -e wheel -e pip -e setuptools | cut -d= -f1 | xargs pip3.9 install --upgrade'
#alias pip38-upgrade-all='pip3.8 list --outdated --format=freeze | grep -v -e wheel -e pip -e setuptools | cut -d= -f1 | xargs pip3.8 install --upgrade'
#alias pip37-upgrade-all='pip3.7 list --outdated --format=freeze | grep -v -e wheel -e pip -e setuptools | cut -d= -f1 | xargs pip3.7 install --upgrade'
alias pip-upgrade-all='pip39-upgrade-all'#'; pip38-upgrade-all; pip37-upgrade-all'

# We set current python to 3.9
alias brew-python='brew-python3.9'
alias 2to3='2to3-3.9'
alias easy_install='easy_install-3.9'
alias idle='idle3.9'
alias pip='pip3.9'
alias pydoc='pydoc3.9'
alias python='python3.9'
alias python-config='python3.9-config'
