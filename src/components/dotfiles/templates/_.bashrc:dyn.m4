#!/bin/bash
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/


### Let’s import the bash completion files
m4_dnl # We put all brews, even arm64 on non-arm64 envs for simplicity
m4_define(`m4_frz_import_completions',m4_dnl
for f in "$1"/*; do
	# shellcheck source=/dev/null
	{ test -r "$f" && source "$f"; } || true
done
)m4_dnl
m4_dnl
m4_dnl
m4_define(`m4_frz_import_brew_completions',m4_dnl
m4_dnl # Completion for cmake is here…
m4_frz_import_completions($1/share/bash-completion/completions)m4_dnl
m4_dnl # More standard completion is here AFAICT
m4_frz_import_completions($1/etc/bash_completion.d)m4_dnl
)m4_dnl
m4_dnl
m4_dnl
m4_ifelse(___M4___DEFAULT_BREW_IS_SYSTEM___M4___, `false',
# First the system Homebrew as the user one is the default.
m4_frz_import_brew_completions(___M4___HOMEBREW_X86_USER_DIR___M4___)m4_dnl
m4_frz_import_brew_completions(___M4___HOMEBREW_ARM64_USER_DIR___M4___)m4_dnl
# Then the user Homebrew.
m4_frz_import_brew_completions(___M4___HOMEBREW_X86_SYSTEM_DIR___M4___)m4_dnl
m4_frz_import_brew_completions(___M4___HOMEBREW_ARM64_SYSTEM_DIR___M4___)m4_dnl
,m4_dnl
# First the user Homebrew as the system one is the default.
m4_frz_import_brew_completions(___M4___HOMEBREW_X86_USER_DIR___M4___)m4_dnl
m4_frz_import_brew_completions(___M4___HOMEBREW_ARM64_USER_DIR___M4___)m4_dnl
# Then the system Homebrew.
m4_frz_import_brew_completions(___M4___HOMEBREW_X86_SYSTEM_DIR___M4___)m4_dnl
m4_frz_import_brew_completions(___M4___HOMEBREW_ARM64_SYSTEM_DIR___M4___)m4_dnl
)m4_dnl
# And finally our 1st and 3rd-party scripts.
m4_frz_import_completions(___M4___THIRD_PARTY_BASH_COMPLETIONS___M4___)m4_dnl
m4_frz_import_completions(___M4___FIRST_PARTY_BASH_COMPLETIONS___M4___)m4_dnl
