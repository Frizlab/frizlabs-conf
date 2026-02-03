# Not -r because we modify this variable in the env specific vars file.
typeset -A PKGS_BREW_USER__FORMULAE=(
	"cliclick" "bin/cliclick"
)

# Not -r because we modify this variable in the env specific vars file.
typeset -A PKGS_BREW_USER__CASKS=(
	"apparency"   "Caskroom/apparency"
	"archaeology" "Caskroom/archaeology"
	"chalk"       "Caskroom/chalk"
	"dash"        "Caskroom/dash"
	"imageoptim"  "Caskroom/imageoptim"
	"mints"       "Caskroom/mints"
	"netnewswire" "Caskroom/netnewswire"
	
	"frizlab/perso/my-web-quirks" "Caskroom/my-web-quirks"
	
	"frizlab/perso/base64"            "Caskroom/base64"
	"xcode-actions/tap/locmapper-app" "Caskroom/locmapper-app"
)


# Sourcing env specific and local vars files.
test -f "./vars/$COMPUTER_GROUP.zsh" && source "./vars/$COMPUTER_GROUP.zsh" || true
test -f "./vars/  local.zsh"         && source "./vars/  local.zsh"         || true
