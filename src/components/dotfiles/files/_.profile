#!/bin/sh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.

# Init file for login POSIX shells.
# See https://github.com/Frizlab/frizlabs-conf for more info.

echo "ENTER: .profile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"



################################################################################
echo "START: .profile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# shellcheck source=/dev/null
# We import the .profile:dyn first because of the variables we could reuse
{ test -r "${HOME}/.profile:dyn" && . "${HOME}/.profile:dyn"; } || true



export EDITOR="vi"

# Locale fix env
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# PATH Management
export PATH="${FRZ_HOMEBREW_PREFIX}/opt/ruby/bin:${PATH}"; # We force using Homebrew’s ruby
export PATH="${FRZ_HOMEBREW_PREFIX}/opt/python@2/bin:${PATH}"; # We force using Homebrew’s Python2…
export PATH="${FRZ_HOMEBREW_PREFIX}/opt/python@3/bin:${PATH}"; # And Python3…
export PATH="${FRZ_HOMEBREW_PREFIX}/opt/python@3/libexec/bin:${PATH}"; # Using Python3 when using an unversioned “python”
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


# Homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
# HOMEBREW_GITHUB_API_TOKEN is set in a separate file
# After further thinking, disabling quarantine might not be the best idea…
#export HOMEBREW_CASK_OPTS="--no-quarantine"


# GPG
# shellcheck disable=SC2155
export GPG_TTY="$(tty)"


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



### Let’s import .profile.d/*.sh files
for f in "${HOME}/.profile.d"/*.sh; do
	# shellcheck source=/dev/null
	{ test -r "$f" && . "$f"; } || true
done

################################################################################


# Now we’ve done everything login-specific, we import the non-standard non-login
# rc file, which sh does not import automatically in a login shell. The import
# is done using the ENV var so children inherit it, and bash does not do the
# import (it is done in .bashrc too).

# Note: We export the ENV var here, but the export is not necessary to make the
#       sh login shell load ~/.shrc
#       However, if we try and launch a non-login sh from a login shell, the
#       .shrc is not loaded if ENV is not exported (obviously)
# Note2: If the ENV is set to a NULL value, we do NOT re-export it to a new
#        value; we assume there as been a good reason for the ENV to be set to
#        NULL and leave it as-is.
export ENV="${ENV-${HOME}/.shrc}"


echo "EXIT: .profile" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"
