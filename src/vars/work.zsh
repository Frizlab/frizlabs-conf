# Environment specific vars: work

# Conf
readonly DARK_MODE=false
readonly DEFAULT_BREW_IS_SYSTEM=true
#readonly GCLOUD_DIR="$CLT_DIR/gougle-cloud-sdk"

# Custom components
DEFAULT_COMPONENTS_TO_INSTALL+=(
#	"nix"             "pkgs-nix-base"
	"homebrew-user"   "pkgs-brew-user"
	"homebrew-system" "pkgs-brew-system"
	
#	"gcloud"
)
