# Homebrew install
function install_homebrew() {
	dir="$1"
	
	test ! -x "$dir/bin/brew" || { echo "ok"; return }
	"$SRC_FOLDER/components/bin/files/bash/install-brew.sh" "$dir" >/dev/null 2>&1 || { log_task_failure "cannot install homebrew at path $dir"; echo "failed"; return }
	echo "changed"
}

## Usage: install_brew_package brew_prefix package_name path_to_check
function install_brew_package() {
	brew_prefix="$1"
	package_name="$2"
	path_to_check="$3"
	
	if test "${path_to_check:0:1}" = "/"; then test ! -e              "$path_to_check" || { echo "ok"; return }
	else                                       test ! -e "$brew_prefix/$path_to_check" || { echo "ok"; return }; fi
	HOMEBREW_NO_ANALYTICS=1 \
	HOMEBREW_NO_AUTO_UPDATE=0 HOMEBREW_AUTO_UPDATE_SECS=259200 \
	HOMEBREW_CASK_OPTS="'--appdir=$HOME/Applications' '--fontdir=$HOME/Library/Fonts'" \
	"$brew_prefix/bin/brew" install -- "$package_name" >/dev/null 2>&1 || { log_task_failure "cannot install using brew in prefix $brew_prefix"; echo "failed"; return }
	echo "changed"
}
