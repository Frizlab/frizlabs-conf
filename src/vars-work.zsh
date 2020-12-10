# Environment specific vars: work
readonly DARK_MODE=false

typeset -rA MAIN_HOMEBREW_PACKAGES=(
	"cloc"                "bin/cloc"
	"coreutils"           "bin/gsed"
	"git-lfs"             "bin/git-lfs"
	"gti"                 "bin/gti"
	"htop"                "bin/htop"
	"jq"                  "bin/jq"
	"lftp"                "bin/lftp"
	"nmap"                "bin/nmap"
	"pass"                "bin/pass"
	"recode"              "bin/recode"
	"rsync"               "bin/rsync"
	"shellcheck"          "bin/shellcheck"
	"speedtest-cli"       "bin/speedtest-cli"
	"the_silver_searcher" "bin/ag"
	"tmux"                "bin/tmux"
	"watch"               "bin/watch"
	"wget"                "bin/wget"
	"youtube-dl"          "bin/youtube-dl"
	"yq"                  "bin/yq"
	
	"frizlab/perso/find-unreferenced-xcode-files" "bin/find-unreferenced-xcode-files"
	
	"mxcl/made/swift-sh" "bin/swift-sh"
	
	"happn-tech/public/locmapper" "Cellar/locmapper"
)
