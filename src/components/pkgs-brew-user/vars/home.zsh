PKGS_BREW_USER__FORMULAE+=(
	"abcm2ps" "bin/abcm2ps"
)

if test "$HOST_OS" != "Linux"; then
	# These formulae do not compile on Linux (at the time of writing), so we only add them when we’re not on Linux.
	PKGS_BREW_USER__FORMULAE+=(
		"frizlab/perso/ls-diff" "bin/ls-diff"
	)
fi
