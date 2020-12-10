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
	
	test ! -e "$brew_prefix/$path_to_check" || { echo "ok"; return }
	"$brew_prefix/bin/brew" install -- "$package_name" >/dev/null 2>&1 || { log_task_failure "cannot install $package_name in brew at path $brew_prefix"; echo "failed"; return }
	echo "changed"
}
