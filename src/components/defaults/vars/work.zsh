# On the work computer, the font has to be smaller because I have a smaller screen.
DEFAULTS__XCODE_THEME_ACTIONS+=(
	"smaller"
)

DEFAULTS__DARK_MODE_FOR_SAFARI_WHITELISTED_SITES+=(
	"app.waldo.com"
)

DEFAULTS__DARK_MODE_FOR_SAFARI_BLACKLISTED_SITES+=(
	"console.firebase.google.com" # Dynamic, not detected as such
	"studio.mojo.video"
)
