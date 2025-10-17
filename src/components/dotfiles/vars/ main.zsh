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

# readonly later only because modified in env-specific var files.
DOTFILES__FOLDERS=(
	".zshenv.d"
	".zprofile.d"
	".zshrc.d"
	".zlogin.d"
	".bash_profile.d"
	".bashrc.d"
	".profile.d"
	".shrc.d"
	".ssh"
	".psql_session"
	".colima"
	".colima/default"
	".config"
	".config/zed"
)

# readonly later only because modified in env-specific var files.
DOTFILES__FILES=(
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
	".psqlrc"
	".justfile"
	".lldbinit"
	".config/zed/settings.json"
	".config/zed/keymap.json"
)

readonly DOTFILES__TEMPLATES=(
	".profile:dyn"
	".shrc:dyn"
	".zshrc:dyn"
	".bashrc:dyn"
	".vimrc:dyn"
	".colima/default/colima.yaml"
	".justfile:dyn"
)

# readonly later only because modified in env-specific var files.
DOTFILES__ENCRYPTED=(
)

readonly DOTFILES__ENCRYPTED_TEMPLATES=(
	".ssh/config"
)

# All colima vars are expected to be changed in env-specific var files.
# We put them readonly after the env-specific var files import.
DOTFILES__COLIMA__NCPU="2"
DOTFILES__COLIMA__MEMORY="8"
DOTFILES__COLIMA__RWMOUNT="/tmp/colima"

# Sourcing env specific vars file
test -f "./vars/$COMPUTER_GROUP.zsh" && source "./vars/$COMPUTER_GROUP.zsh" || true


readonly DOTFILES__FOLDERS
readonly DOTFILES__FILES
readonly DOTFILES__ENCRYPTED
readonly DOTFILES__COLIMA__NCPU
readonly DOTFILES__COLIMA__MEMORY
readonly DOTFILES__COLIMA__RWMOUNT
