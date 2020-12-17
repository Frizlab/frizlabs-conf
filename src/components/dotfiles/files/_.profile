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



# PATH and other env var depending on conf variables is done in .profile:dyn

# We use vi, the only real editor
export EDITOR="vi"

# Locale fix env
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_DISPLAY_INSTALL_TIMES=1
# HOMEBREW_CASK_OPTS and HOMEBREW_GITHUB_API_TOKEN are set in profile:dyn


# GPG
# shellcheck disable=SC2155
export GPG_TTY="$(tty)"



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
