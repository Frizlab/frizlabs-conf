# Not -r because we modify this variable in the env specific vars file
typeset -a DEFAULTS__XCODE_THEME_ACTIONS=(
	"mono"
)


# Sourcing env specific vars file
test -f "./vars/$COMPUTER_GROUP.zsh" && source "./vars/$COMPUTER_GROUP.zsh" || true
