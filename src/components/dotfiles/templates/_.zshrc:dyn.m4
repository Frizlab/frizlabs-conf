#!/bin/zsh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/

### Let’s change the fpath
m4_dnl # We put all brews, even arm64 on non-arm64 envs for simplicity
# First homebrew
m4_define(`m4_frz_add_to_fpath',m4_dnl
fpath+=("$1")
)m4_dnl
m4_define(`m4_frz_import_brew_completions', m4_frz_add_to_fpath($1/share/zsh/site-functions))m4_dnl
m4_frz_import_brew_completions(___M4___HOMEBREW_X86_SYSTEM_DIR___M4___)m4_dnl
m4_frz_import_brew_completions(___M4___HOMEBREW_ARM64_SYSTEM_DIR___M4___)m4_dnl
m4_frz_import_brew_completions(___M4___HOMEBREW_X86_USER_DIR___M4___)m4_dnl
m4_frz_import_brew_completions(___M4___HOMEBREW_ARM64_USER_DIR___M4___)m4_dnl
# Then our 1st and 3rd-party scripts
m4_frz_add_to_fpath(___M4___THIRD_PARTY_ZSH_SITE_FUNCTIONS___M4___)m4_dnl
m4_frz_add_to_fpath(___M4___FIRST_PARTY_ZSH_SITE_FUNCTIONS___M4___)m4_dnl

# And then call compinit
autoload -Uz compinit && compinit
