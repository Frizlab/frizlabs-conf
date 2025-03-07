# Source other vars (the file is split for readability).
source "$SRC_FOLDER/vars/ main0-macosdirs.zsh"
source "$SRC_FOLDER/vars/ main1-clt-tree.zsh"
source "$SRC_FOLDER/vars/ main2-homebrew.zsh"
source "$SRC_FOLDER/vars/ main3-envs.zsh"


# Not -r because we modify this variable in the env specific vars file
typeset -a DEFAULT_COMPONENTS_TO_INSTALL=(
	"core"
	"dotfiles"
	"bin"
)
if [ "$HOST_OS" = "Darwin" ]; then
	DEFAULT_COMPONENTS_TO_INSTALL+=(
		"launchd"
		"defaults"
	)
fi


# Sourcing env specific vars file
source "$SRC_FOLDER/vars/$COMPUTER_GROUP.zsh"
