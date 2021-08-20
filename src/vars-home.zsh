# Environment specific vars: home
readonly DARK_MODE=true

COMPONENTS+=(
#	"nix"             "pkgs-nix-base"
	"homebrew-user"   "pkgs-brew-user-base"
	"homebrew-system" "pkgs-brew-system-base"
)

readonly DEFAULT_BREW_IS_SYSTEM=false
MAIN_USER_HOMEBREW_FORMULAE+=(
	"abcm2ps" "bin/abcm2ps"
)

if test "$HOST_OS" != "Linux"; then
	# These formulae do not compile on Linux (at the time of writing), so we only
	# add them when we’re not on Linux.
	MAIN_USER_HOMEBREW_FORMULAE+=(
		"frizlab/perso/ls-diff" "bin/ls-diff"
	)
fi
