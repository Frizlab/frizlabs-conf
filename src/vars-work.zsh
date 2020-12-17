# Environment specific vars: work
readonly DARK_MODE=false

readonly DEFAULT_BREW_IS_SYSTEM=true

readonly GCLOUD_DIR="$CLT_DIR/gougle-cloud-sdk"
COMPONENTS+=(
	"gcloud"
)

MAIN_SYSTEM_HOMEBREW_CASKS+=(
	"firefox" "Caskroom/firefox"
)
