# The Applications directory.
readonly HOMEBREW_GITHUB_TOKEN_ENCRYPTED="jPf2eWoOaSczcvJQ/SMlXLxxrEx5nR5xOTctBwP+DNnvSP172HU/WdW6aKzBDBbmXMJoYsNHyr2Q6UK0fDMJ+LAdx2xfKSpgsQT7eVCbekWCGJ6jUpPIs+ORluzhiSZXCWqJ/oPMn6dsyF1kFOZmediu86e2h8Cu9vPUjo2jpQSGdRJyEehWmw=="
readonly HOMEBREW_GITHUB_TOKEN="$(decrypt_string "$HOMEBREW_GITHUB_TOKEN_ENCRYPTED")"

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
