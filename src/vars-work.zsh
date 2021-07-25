# Environment specific vars: work
readonly DARK_MODE=false

readonly DEFAULT_BREW_IS_SYSTEM=true

readonly GCLOUD_DIR="$CLT_DIR/gougle-cloud-sdk"
COMPONENTS+=(
	"gcloud"
	"homebrew-user-pythons"
)

MAIN_SYSTEM_HOMEBREW_CASKS+=(
	# Not needed anymore; now it’s installed via Munki
#	"firefox" "Caskroom/firefox"
)
