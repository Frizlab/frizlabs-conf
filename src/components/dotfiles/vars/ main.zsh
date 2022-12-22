# The Applications directory.
readonly DOTFILES__HOMEBREW_GITHUB_TOKEN_ENCRYPTED='
	jPf2eWoOaSczcvJQ/SMlXLxxrEx5nR5xOTctBwP+DNnvSP172HU/WdW6aKzBDBbmXMJoYsNHyr2Q6
	UK0fDMJ+LAdx2xfKSpgsQT7eVCbekWCGJ6jUpPIs+ORluzhiSZXCWqJ/oPMn6dsyF1kFOZmediu86
	e2h8Cu9vPUjo2jpQSGdRJyEehWmw=='

CURRENT_TASK_NAME="decrypt HOMEBREW_GITHUB_TOKEN"
catchout decrypted_string  libccrypt__decrypt_string "$DOTFILES__HOMEBREW_GITHUB_TOKEN_ENCRYPTED"
readonly DOTFILES__HOMEBREW_GITHUB_TOKEN="$decrypted_string"
unset decrypted_string


readonly DOTFILES__BACKUP_DIR="$HOME/.:dotfiles_backups"
readonly DOTFILES__BACKUP_DIR_MODE="700"

readonly DOTFILES__FOLDERS=(
	".zshenv.d"
	".zprofile.d"
	".zshrc.d"
	".zlogin.d"
	".bash_profile.d"
	".bashrc.d"
	".profile.d"
	".shrc.d"
	".ssh"
)

readonly DOTFILES__FILES=(
	".zshenv"
	".zprofile"
	".zshrc"
	".zlogin"
	".bash_profile"
	".bashrc"
	".profile"
	".shrc"
	".vimrc"
	".inputrc"
	".gitconfig"
	".gitignore_global"
)

readonly DOTFILES__TEMPLATES=(
	".profile:dyn"
	".shrc:dyn"
	".zshrc:dyn"
	".bashrc:dyn"
	".vimrc:dyn"
	".colima/default/colima.yaml"
)

readonly DOTFILES__ENCRYPTED=(
	".ssh/config-$COMPUTER_GROUP"
)

readonly DOTFILES__ENCRYPTED_TEMPLATES=(
	".ssh/config"
)

# All colima vars are expected to be changed in env-specific var files.
DOTFILES__COLIMA__NCPU="2"
DOTFILES__COLIMA__MEMORY="8"
DOTFILES__COLIMA__RWMOUNT="/tmp"

# Sourcing env specific vars file
test -f "./vars/$COMPUTER_GROUP.zsh" && source "./vars/$COMPUTER_GROUP.zsh" || true
