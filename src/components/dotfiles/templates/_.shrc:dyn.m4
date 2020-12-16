#!/bin/sh
# vim: ts=3 sw=3 noet
# The shebang is not necessarily needed, but shellcheck wants it.
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/
#
#    THIS FILE IS MANAGED, ALL LOCAL EDITS WILL BE OVERWRITTEN!
#
# \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/ \!/

m4_dnl # M4 Utils for Brew
m4_dnl
m4_define(`m4_frz_brew_cask_user_env', m4_dnl
'--appdir=$HOME/Applications'm4_dnl
)m4_dnl
m4_define(`m4_frz_brew_cask_system_env', m4_dnl
m4_dnl # Update the list from `man brew` from time to time
'--colorpickerdir=/Library/ColorPickers' m4_dnl
'--prefpanedir=/Library/PreferencePanes' m4_dnl
'--qlplugindir=/Library/QuickLook' m4_dnl
'--mdimporterdir=/Library/Spotlight' m4_dnl
'--dictionarydir=/Library/Dictionaries' m4_dnl
'--fontdir=/Library/Fonts' m4_dnl
'--servicedir=/Library/Services' m4_dnl
'--input_methoddir=/Library/Input Methods' m4_dnl
'--internet_plugindir=/Library/Internet Plug-Ins' m4_dnl
'--audio_unit_plugindir=/Library/Audio/Plug-Ins/Components' m4_dnl
'--vst_plugindir=/Library/Audio/Plug-Ins/VST' m4_dnl
'--vst3_plugindir=/Library/Audio/Plug-Ins/VST3' m4_dnl
'--screen_saverdir=/Library/Screen Savers' m4_dnl
)m4_dnl
# brew aliases
m4_ifelse(___M4___DEFAULT_BREW_IS_SYSTEM___M4___, `false',
alias brew='brew-user'
alias brew-arm64='brew-user-arm64'
alias brew-x86='brew-user-x86'
,m4_dnl
alias brew='brew-system'
alias brew-arm64='brew-system-arm64'
alias brew-x86='brew-system-x86'
)m4_dnl
m4_dnl # These are the brew aliases, for the different arches.
m4_dnl # We only do this on macOS; for Linux we always use the “native” brew.
m4_ifelse(___M4___HOST_OS___M4___, `Darwin',m4_dnl
m4_ifelse(___M4___HOST_ARCH___M4___, `arm64',m4_dnl
alias   brew-user='brew-user-arm64'
alias brew-system='brew-system-arm64'
alias brew-user-arm64='HOMEBREW_CASK_OPTS="'"m4_frz_brew_cask_user_env"' $FRZ_HOMEBREW_CASK_OPTS"              ___M4___HOMEBREW_ARM64_USER_DIR___M4___/bin/brew'
alias   brew-user-x86='HOMEBREW_CASK_OPTS="'"m4_frz_brew_cask_user_env"' $FRZ_HOMEBREW_CASK_OPTS" arch -x86_64 ___M4___HOMEBREW_X86_USER_DIR___M4___/bin/brew'
alias brew-system-arm64='HOMEBREW_CASK_OPTS="'"m4_frz_brew_cask_system_env"' $FRZ_HOMEBREW_CASK_OPTS"              ___M4___HOMEBREW_ARM64_SYSTEM_DIR___M4___/bin/brew'
alias   brew-system-x86='HOMEBREW_CASK_OPTS="'"m4_frz_brew_cask_system_env"' $FRZ_HOMEBREW_CASK_OPTS" arch -x86_64 ___M4___HOMEBREW_X86_SYSTEM_DIR___M4___/bin/brew'
,m4_dnl
alias   brew-user='brew-user-x86'
alias brew-system='brew-system-x86'
alias   brew-user-x86='HOMEBREW_CASK_OPTS="'"m4_frz_brew_cask_user_env"' $FRZ_HOMEBREW_CASK_OPTS" ___M4___HOMEBREW_X86_USER_DIR___M4___/bin/brew'
alias brew-user-arm64='echo "error: arm64 brew not available on this platform+arch" >&2; false'
alias   brew-system-x86='HOMEBREW_CASK_OPTS="'"m4_frz_brew_cask_system_env"' $FRZ_HOMEBREW_CASK_OPTS" ___M4___HOMEBREW_X86_SYSTEM_DIR___M4___/bin/brew'
alias brew-system-arm64='echo "error: arm64 brew not available on this platform+arch" >&2; false'
))m4_dnl
