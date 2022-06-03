# Not -r because we modify this variable in the env specific vars file.
typeset -A PKGS_BREW_USER__FORMULAE=(
)

# Not -r because we modify this variable in the env specific vars file.
typeset -A PKGS_BREW_USER__CASKS=(
	"chalk"       "Caskroom/chalk"
	"dash"        "Caskroom/dash"
	"imageoptim"  "Caskroom/imageoptim"
	"netnewswire" "Caskroom/netnewswire"
	
	"frizlab/perso/my-web-quirks" "Caskroom/my-web-quirks"
	
	"happn-app/public/base64"           "Caskroom/base64"
	"happn-app/public/locmapper-app"    "Caskroom/locmapper-app"
	"happn-app/public/locmapper-linter" "Caskroom/locmapper-linter"
)


# Sourcing env specific vars file
test -f "./vars/$COMPUTER_GROUP.zsh" && source "./vars/$COMPUTER_GROUP.zsh" || true
