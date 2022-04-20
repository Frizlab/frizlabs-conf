# Environment specific vars: work
readonly DARK_MODE=false

readonly DEFAULT_BREW_IS_SYSTEM=true

readonly GCLOUD_DIR="$CLT_DIR/gougle-cloud-sdk"
COMPONENTS+=(
#	"nix"             "pkgs-nix-base"
	"homebrew-user"   "pkgs-brew-user-base"
	"homebrew-system" "pkgs-brew-system-base"
	
	"gcloud"
)

MAIN_SYSTEM_HOMEBREW_FORMULAE+=(
	"ansible" "bin/ansible"
)

MAIN_SYSTEM_HOMEBREW_CASKS+=(
	# Not needed anymore; now it’s installed via Munki
#	"firefox" "Caskroom/firefox"
)
