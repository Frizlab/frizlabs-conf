#!/bin/bash

# Init file for login shells
# Most of the instructions here should be in the .bashrc file...

function show_branch1() {
	if git branch >/dev/null 2>&1; then printf "["; fi
}

function show_branch2() {
	# No need for more than 2 lines of status in theory as untracked are shown at the end
	status="$(git status -b --porcelain 2>/dev/null | head -n 3)"
	status_ret=${PIPESTATUS[0]}
	if [ "$status_ret" -ne 0 ]; then return; fi
	
	printf "%s" "$(echo "$status" | sed -En '/^## /s///p')"
	if   echo "$status" | grep -Eq '^[^#?]'; then printf '*'
	elif echo "$status" | grep -Eq '^\?';    then printf '~'
	fi
}

function show_branch3() {
	if git branch >/dev/null 2>&1; then printf "]"; fi
}

# \W: last path component
# You can comment the following lines to come back to the default prompt.
# IMPORTANT NOTE: The colors should be set directly within the variable, not from the output of the
#                 show_branch* methods (which is why there are three methods...) because of a Terminal
#                 bug (probably).
export PS1='\[\033[01;36m\]\#\[\033[0m\] \\ \[\033[00;32m\]\t\[\033[0m\] / \[\033[00;33m\]\u@\h\[\033[0m\][\[\033[00;31m\]$?\[\033[0m\]] \[\033[01;38m\]\w\[\033[0m\]) '
export PS1='\[\033[01;36m\]\#\[\033[0m\] \\ \[\033[00;32m\]\t\[\033[0m\] / \[\033[00;33m\]\u@\h\[\033[0m\][\[\033[00;31m\]$?\[\033[0m\]] \[\033[01;38m\]\w\[\033[0m\]`show_branch1`\[\033[00;31m\]`show_branch2`\[\033[0m\]`show_branch3`) '
# We may want to set PS2 too. It sets the prompt shown after a return when the command line is not finished.

export EDITOR='vi'

# Aliases for ls
alias ls='ls -FG'
alias l='ls -C'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls -lrt'

# Dev. aliases
# shellcheck disable=SC2142
alias gt="git tag | xargs -I@ git log --format=format:\"%ai @%n\" -1 @ | sort | awk '{print \$4}'"; # Outputs git tags in reverse chronological order
alias xcsymbolicate='DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer/ /Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash'
alias docker-run-swift='docker run --security-opt=seccomp:unconfined -v "$(pwd):/mnt/output" -it --rm --entrypoint bash happn/swift-builder'

# Other aliases
#alias cat='bat'
alias upgrade_packages="brew update; brew upgrade; brew cask upgrade; gem update; pip2-upgrade-all; pip3-upgrade-all"
alias upgrade_packages_force_build="brew update; brew upgrade --build-from-source; brew cask upgrade; gem update; pip2-upgrade-all; pip3-upgrade-all"

# Dev. Functions
function find_lib_with() {
	if [ -z "$1" ]; then echo "Usage: find_lib_with object_name" >/dev/stderr; return 1; fi
	mdfind -name .dylib | while read -r f; do if [ "$(nm -U "$f" 2>/dev/null | grep -Ec "$1\$")" -gt 0 ]; then echo "$f"; fi; done
}

function find_brew_deps() {
	if [ -z "$1" ]; then echo "Usage: find_brew_deps path_to_cellar (eg. \"find_brew_deps /usr/local/Cellar/gegl/0.1.8/\")" >/dev/stderr; return 1; fi
	otool -L "$1"/*/* 2>/dev/null | cut -f 1 -d ' ' | while read -r f; do ls -lFG "$f" 2>/dev/null; done
}

function rec_grep() {
	if [ -z "$1" ] || [ -z "$2" ]; then echo "Usage: rec_grep files_pattern grepped_expr" >/dev/stderr; return 1; fi
	find . -name "$1" -type f -exec grep -E "$(echo "$2" | sed -E 's/"/\\"/g')" {} \; -exec echo {} \;
}

function ssha() {
	while true; do ssh "$@"; sleep 1; done
	true
}

# Misc. aliases
alias x='chmod ug+x'
alias top='top -o cpu'
alias rem='trash'
alias cd..='cd ..'
alias h='cat ~/.bash_sessions/*.history*'

# Misc. functions
function kill_dock() {
	osascript -e 'tell application "Dock" to quit'
}

function del_stores() {
	# Note: Cannot give "/" in input!
	dir="$(echo "$1" | sed -E 's:/*$::')"
	if [ -z "$dir" ]; then echo "Usage: del_stores dir" >/dev/stderr; return 1; fi
	if [ ! -d "$dir" ]; then echo "dir does not exist or is not a directory" >/dev/stderr; return 2; fi
	find "$dir" -name ".DS_Store" -print -delete
}

function add_subtitle() {
	if [ $# -ne 1 ] && [ $# -ne 2 ]; then echo "usage: \"add_subtitle movie_name.\" or \"add_subtitle srt_file.srt movie_file.mp4\"" >/dev/stderr; return 1; fi
	if [ $# -eq 1 ]; then
		srt="${1}srt"
		mp4="${1}mp4"
	else
		srt="$1"
		mp4="$2"
	fi
	MP4Box -add "${srt}:lang=eng:layout=0x60x0x-1:group=2:hdlr=sbtl:tx3g" "$mp4" && rm "$srt"
}

# Locale fix env
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Bash history control. Set to ignore duplicates in
# history, as well as lines starting with a space
# Note: An alias for this is ignoreboth
export HISTCONTROL=ignoredups:ignorespace

# !12 will retype command #12, NOT reexecute it without asking
shopt -s histverify

# Allow one-off typing errors
# https://www.gnu.org/software/bash/manual/bashref.html#The-Set-Builtin
shopt -s cdspell



# PATH Management
export PATH="${HOME}/usr/homebrew/opt/ruby/bin:${PATH}"; # We force using Homebrew’s ruby
export PATH="${HOME}/usr/homebrew/opt/python@2/bin:${PATH}"; # We force using Homebrew’s Python2…
export PATH="${HOME}/usr/homebrew/opt/python@3/bin:${PATH}"; # And Python3…
export PATH="${HOME}/usr/homebrew/opt/python/libexec/bin:${PATH}"; # Using Python3 when using an unversioned “python”
export PATH="${PATH}:/usr/local/sbin"
export PATH="${PATH}:${HOME}/usr/bin"
export PATH="${PATH}:${HOME}/usr/homebrew/bin"
export PATH="${PATH}:${HOME}/usr/cappuccino/bin"
#export PATH="${PATH}:${HOME}/Library/Python/*/bin"; # For system Python when installing in user path
export PATH="${PATH}:${HOME}/usr/ruby/bin"
export PATH="${PATH}:${HOME}/usr/npm/bin"
export PATH="${PATH}:${HOME}/usr/go/bin"
export PATH="${PATH}:."

# Compilation options management for custom install brew
export LDFLAGS="${LDFLAGS} -L${HOME}/usr/homebrew/lib"
export CFLAGS="${CFLAGS} -I${HOME}/usr/homebrew/include"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${HOME}/usr/homebrew/lib/pkgconfig"


# shellcheck source=/dev/null
# /usr/local bash completion
# This should probably be in .bashrc rather than in the .bash_profile
for f in "/usr/local/etc/bash_completion.d"/*; do test -f "$f" && source "$f"; done


# Homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
# HOMEBREW_GITHUB_API_TOKEN is set in a separate file
export HOMEBREW_CASK_OPTS="--no-quarantine"
# shellcheck source=/dev/null
# This should probably be in .bashrc rather than in the .bash_profile
for f in "${HOME}/usr/homebrew/etc/bash_completion.d"/*; do test -f "$f" && source "$f"; done


# GPG
# shellcheck disable=SC2155
export GPG_TTY="$(tty)"


# Python
# --> We use the brewed Python. Nothing fancy to do for Python!
#     Eggs are installed in homebrew prefix with pip2 or pip3.
alias pip2-upgrade-all='pip2 list --outdated --format=freeze | grep -v -e wheel -e pip -e setuptools | cut -d= -f1 | xargs pip2 install --upgrade'
alias pip3-upgrade-all='pip3 list --outdated --format=freeze | grep -v -e wheel -e pip -e setuptools | cut -d= -f1 | xargs pip3 install --upgrade'


# Ruby
export GEM_HOME="${HOME}/usr/ruby"


# Cappuccino
export NARWHAL_ENGINE=jsc
export CAPP_BUILD="${HOME}/Library/Caches/Cappuccino/DerivedData"


# NPM
export NPM_CONFIG_PREFIX="${HOME}/usr/npm"


# Go
export GOPATH="${HOME}/usr/go"



### Let’s import .bash_profile:dyn and .bash_profile.d/*.sh files
for f in "${HOME}/.bash_profile.d"/*.sh "${HOME}/.bash_profile:dyn"; do
	# shellcheck source=/dev/null
	test -f "$f" && source "$f"
done
