# Install an admin-owned Homebrew.


# ⚠️ IMPORTANT
# If it is needed, the install will probably fail, because we do not ask for sudo.
# Will we ask for it one day? Maybe.
# But right now we do not.
#
# A trick to get sudo during the duration of the script: <https://github.com/nnja/new-computer/blob/master/setup.sh#L73>.
#    sudo -v
#    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
#
#
# Another thing: Installing Homebrew in /usr/local is not supported by the script we use to install Homebrew.
# Homebrew workarounds /usr/local not being writable without sudo by installing itself in /usr/local/Homebrew instead and
#  creating only the required folders in /usr/local and
#  symlinking stuff from the Homebrew folder to the expected folders.
#
# Basically the install should be done more or less this way: <https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh> simplified.
#    cd /usr/local
#    directories=(bin etc include lib sbin share var opt
#                 share/zsh share/zsh/site-functions
#                 var/homebrew var/homebrew/linked
#                 Cellar Caskroom Homebrew Frameworks)
#    for d in $directories; do sudo mkdir "$d"; done
#    for d in $directories; do sudo chown -h frizlab:staff "$d"; done
#    curl -SL https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C /usr/local/Homebrew
#    ln -sf /usr/local/Homebrew/bin/brew /usr/local/bin/brew
#    /usr/local/bin/brew update --force
#
# We should modify the script so it supports installing to a custom Homebrew prefix, with a custom install folder
#  (untar in custom install folder, and create necessary directories in Homebrew prefix, then link brew, then brew update).


case "$HOST_OS:$HOST_ARCH" in
	Darwin:arm64)
		start_task "install system homebrew arm64"; catchout RES  libbrew__install_homebrew                         "$HOMEBREW_ARM64_SYSTEM_DIR"; log_task_from_res "$RES"
		# We should not need x86 brew on M1 anymore, so we skip the system one as it pollutes /usr/local.
#		start_task "install system homebrew x86";   catchout RES  libbrew__install_homebrew "--force-arch" "x86_64" "$HOMEBREW_X86_SYSTEM_DIR";   log_task_from_res "$RES"
	;;
	
	Linux:aarch64)
		start_task "install system homebrew arm64"; catchout RES  libbrew__install_homebrew "$HOMEBREW_ARM64_SYSTEM_DIR"; log_task_from_res "$RES"
		# A Rosetta-like stuff exists on Linux apparently, but it’s a bit complex to setup and we do not need it, so no x86 homebrew on arm Linux.
		# <https://ownyourbits.com/2018/06/13/transparently-running-binaries-from-any-architecture-in-linux-with-qemu-and-binfmt_misc/>
	;;
	
	Darwin:x86_64|Linux:x86_64)
		start_task "install system homebrew x86";   catchout RES  libbrew__install_homebrew "$HOMEBREW_X86_SYSTEM_DIR"; log_task_from_res "$RES"
	;;
	
	*)
		start_task "install system homebrew (unknown arch)"
		log_task_failure "cannot install system homebrew on unknown arch"
	;;
esac
