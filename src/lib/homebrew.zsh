# Homebrew install
readonly FRZ_HOMEBREW_CASK_OPTS_BASE="\
'--skip-cask-deps' \
'--no-binaries'"
# After further thinking, disabling quarantine might not be the best idea…
#FRZ_HOMEBREW_CASK_OPTS_BASE+=" '--no-quarantine'"

# Update the list from `man brew` from time to time.

readonly FRZ_HOMEBREW_CASK_OPTS_USER="\
'--appdir=$HOME/Applications' \
'--colorpickerdir=$HOME/Library/ColorPickers' \
'--prefpanedir=$HOME/Library/PreferencePanes' \
'--qlplugindir=$HOME/Library/QuickLook' \
'--mdimporterdir=$HOME/Library/Spotlight' \
'--dictionarydir=$HOME/Library/Dictionaries' \
'--fontdir=$HOME/Library/Fonts' \
'--servicedir=$HOME/Library/Services' \
'--input_methoddir=$HOME/Library/Input Methods' \
'--internet_plugindir=$HOME/Library/Internet Plug-Ins' \
'--audio_unit_plugindir=$HOME/Library/Audio/Plug-Ins/Components' \
'--vst_plugindir=$HOME/Library/Audio/Plug-Ins/VST' \
'--vst3_plugindir=$HOME/Library/Audio/Plug-Ins/VST3' \
'--screen_saverdir=$HOME/Library/Screen Savers'"

readonly FRZ_HOMEBREW_CASK_OPTS_SYSTEM="\
'--appdir=/Applications' \
'--colorpickerdir=/Library/ColorPickers' \
'--prefpanedir=/Library/PreferencePanes' \
'--qlplugindir=/Library/QuickLook' \
'--mdimporterdir=/Library/Spotlight' \
'--dictionarydir=/Library/Dictionaries' \
'--fontdir=/Library/Fonts' \
'--servicedir=/Library/Services' \
'--input_methoddir=/Library/Input Methods' \
'--internet_plugindir=/Library/Internet Plug-Ins' \
'--audio_unit_plugindir=/Library/Audio/Plug-Ins/Components' \
'--vst_plugindir=/Library/Audio/Plug-Ins/VST' \
'--vst3_plugindir=/Library/Audio/Plug-Ins/VST3' \
'--screen_saverdir=/Library/Screen Savers'"

function install_homebrew() {
	local -a arch_launch
	if test "$1" = "--force-arch"; then shift; arch_launch=("arch" "-$1"); shift; fi
	
	local -r dir="$1"
	
	test ! -x "$dir/bin/brew" || { echo "ok"; return }
	"${arch_launch[@]}" "$SRC_FOLDER/components/bin/files/bash/install-brew.sh" "$dir" >/dev/null 2>&1 || { log_task_failure "cannot install homebrew at path $dir"; echo "failed"; return }
	echo "changed"
}

## Usage: install_brew_package brew_prefix package_name path_to_check
function install_brew_package() {
	local -a arch_launch
	if test "$1" = "--force-arch"; then shift; arch_launch=("arch" "-$1"); shift; fi
	
	local -r brew_prefix="$1"
	local -r package_name="$2"
	local -r path_to_check="$3"
	shift; shift; shift
	
	local additional_cask_options
	case "$brew_prefix" in
		$HOMEBREW_X86_USER_DIR|$HOMEBREW_ARM64_USER_DIR)     additional_cask_options="$FRZ_HOMEBREW_CASK_OPTS_USER";;
		$HOMEBREW_X86_SYSTEM_DIR|$HOMEBREW_ARM64_SYSTEM_DIR) additional_cask_options="$FRZ_HOMEBREW_CASK_OPTS_SYSTEM";;
	esac
	readonly additional_cask_options
	
	if test "${path_to_check:0:1}" = "/"; then test ! -e              "$path_to_check" || { echo "ok"; return }
	else                                       test ! -e "$brew_prefix/$path_to_check" || { echo "ok"; return }; fi
	HOMEBREW_NO_ANALYTICS=1 \
	HOMEBREW_NO_AUTO_UPDATE=0 HOMEBREW_AUTO_UPDATE_SECS=259200 \
	HOMEBREW_CASK_OPTS="$FRZ_HOMEBREW_CASK_OPTS_BASE $additional_cask_options" \
	"${arch_launch[@]}" "$brew_prefix/bin/brew" install "$@" -- "$package_name" >/dev/null 2>&1 || { log_task_failure "cannot install using brew in prefix $brew_prefix"; echo "failed"; return }
	echo "changed"
}
