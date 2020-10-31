#!/bin/bash
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
echo "ENTER: .bashrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"

# Init file for non-login interactive bash shell
# See https://github.com/Frizlab/frizlabs-conf for more info.


# shellcheck source=_.shrc
# Let’s first include the non-standard non-bash specific rc file
{ test -r "${HOME}/.shrc" && source "${HOME}/.shrc"; } || true

################################################################################
echo "START: .bashrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"


# Aliases for ls
alias ls='ls -FG'
alias l='ls -C'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls -lrt'

# Dev. aliases
# shellcheck disable=SC2142
alias gt="git tag -l --format='%(taggerdate:iso8601)|%(refname:short)' | sort | awk '-F|' '{print \$2}'"; # Outputs git tags in reverse chronological order (close enough at least; dates can have different time zones)
alias xcsymbolicate='DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer/ /Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash'
alias docker-run-swift='docker run --security-opt=seccomp:unconfined -v "$(pwd):/mnt/output" -it --rm --entrypoint bash happn/swift'

# Misc. aliases
alias x='chmod ug+x'
alias top='top -o cpu'
alias rem='trash'
alias cd..='cd ..'
alias h='cat ~/.bash_sessions/*.history*'
alias kill_dock="osascript -e 'tell application \"Dock\" to quit'"

# /usr/local bash completion
# shellcheck source=/dev/null
for f in "/usr/local/etc/bash_completion.d"/*; do ( test -f "$f" && source "$f" ) || true; done

# Homebrew
# shellcheck source=/dev/null
for f in "${HOME}/usr/homebrew/etc/bash_completion.d"/*; do ( test -f "$f" && source "$f" ) || true; done


### Let’s import .bashrc:dyn and .bashrc.d/*.sh files
for f in "${HOME}/.bashrc.d"/*.sh "${HOME}/.bashrc:dyn"; do
	# shellcheck source=/dev/null
	{ test -r "$f" && source "$f"; } || true
done


################################################################################

echo "EXIT: .bashrc" >>"${FRZCNF_SH_INIT_DEBUG_OUTPUT:-/dev/null}"
