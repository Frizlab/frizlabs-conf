# Environment specific vars: home

# Conf
readonly DARK_MODE=true
readonly DEFAULT_BREW_IS_SYSTEM=false

# Custom components
DEFAULT_COMPONENTS_TO_INSTALL+=(
#	"nix"             "pkgs-nix-base"
	"homebrew-user"   "pkgs-brew-user"
	"homebrew-system" "pkgs-brew-system"
)
