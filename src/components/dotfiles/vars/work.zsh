DOTFILES__FOLDERS+=(
	".config/gh"
)

DOTFILES__FILES+=(
	".config/gh/config.yml"
)

DOTFILES__ENCRYPTED+=(
	".ssh/config-$COMPUTER_GROUP"
)

DOTFILES__COLIMA__MEMORY="12"
DOTFILES__COLIMA__RWMOUNT="/Users/frizlab/Developer"
