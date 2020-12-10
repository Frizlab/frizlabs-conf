# The Applications directory.
readonly HOMEBREW_GITHUB_TOKEN_ENCRYPTED='
	jPf2eWoOaSczcvJQ/SMlXLxxrEx5nR5xOTctBwP+DNnvSP172HU/WdW6aKzBDBbmXMJoYsNHyr2Q6
	UK0fDMJ+LAdx2xfKSpgsQT7eVCbekWCGJ6jUpPIs+ORluzhiSZXCWqJ/oPMn6dsyF1kFOZmediu86
	e2h8Cu9vPUjo2jpQSGdRJyEehWmw=='
# decrypt_string does not fail, otherwise we’d have to use a temp variable to
# get the error.
CURRENT_TASK_NAME="decrypt HOMEBREW_GITHUB_TOKEN"
readonly HOMEBREW_GITHUB_TOKEN="$(decrypt_string "$HOMEBREW_GITHUB_TOKEN_ENCRYPTED")"

readonly DOTFILES_BACKUP_DIR="$HOME/.:dotfiles_backups"
readonly DOTFILES_BACKUP_DIR_MODE="700"

readonly DOTFILE_FOLDERS=(
	".zshenv.d"
	".zprofile.d"
	".zshrc.d"
	".zlogin.d"
	".bash_profile.d"
	".bashrc.d"
	".profile.d"
	".shrc.d"
)

readonly DOTFILE_FILES=(
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

readonly DOTFILE_TEMPLATES=(
	".profile:dyn"
	".vimrc:dyn"
)
