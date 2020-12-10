######### Renamed #########

delete_bin "frizlab" "local_brew_install"
delete_bin "frizlab" "set_sound_volume"
delete_bin "frizlab" "get_mount_points"
delete_bin "frizlab" "is_desktop_picture"
delete_bin "frizlab" "merge_strings"
delete_bin "frizlab" "is_valid_jpeg"
delete_bin "frizlab" "backup_cloud"
delete_bin "frizlab" "GetTextEncoding"
delete_bin "frizlab" "brew_find_poured_from_bottle"
delete_bin "frizlab" "find_unreferenced_xcode_files"
delete_bin "ian.abbott" "ansi_colors"
delete_bin "frizlab" "abcm2pdf_runabc"
delete_bin "frizlab" "find_invalid_images"
delete_bin "frizlab" "import_to_photos"
delete_doc "frizlab" "import_to_photos/import_to_photos.scpt"
delete_bin "bbsteam" "bash_arrays"
delete_bin "frizlab" "ios_backup_to_files"
delete_bin "galloglass" "ls_mbdb"
delete_bin "frizlab" "check_itunes_artworks"
delete_bin "frizlab" "remove_xattr"
delete_bin "frizlab" "find_desktop_pictures"
delete_bin "frizlab" "launch_alarm_clock"
delete_bin "frizlab" "connect_netsoul"
delete_bin "frizlab" "persistent_netsoul"
delete_bin "frizlab" "fill_empty_dirs"
delete_bin "frizlab" "remove_quarantine"
delete_bin "frizlab" "make_link"
delete_bin "frizlab" "my_split"


######### Deleted #########

### Local Homebrew Install ###
# Reason: Replaced by a script to install homebrew unconditionally
delete_bin "frizlab" "local-brew-install"

### Xcode Project Version Manager ###
# Original author: Joachim Bondo
# Reason: Far better solutions exist on the Internet
delete_bin "frizlab" "xcode-project-version-manager"

### Find “Unreferenced” Files in an Xcode Project ###
# Original author: Joachim Bondo
# Reason: This tool can now be installed via Homebrew
delete_bin "frizlab" "find-unreferenced-xcode-files"

### Merge Xcode strings Files ###
# Original author was João Moreno but I rewrote pretty much everything.
# Reason: Obsoleted by LocMapper
delete_bin "frizlab" "merge-strings"

### Markdown Render Opener ###
# Reason: Not useful anymore; might re-create later if needed
delete_bin "frizlab" "markdown"

### Code Beautifier for C++ ###
# Version: 1.2
# Reason: 32-bits only; upstream could not be found
delete_bin "lingxiaofeng" "codebt"

### mo3 encoder and decoder ###
# Reason: 32-bits only; upstream could not be found; can most likely be replaced by ffmpeg
delete_bin "<unknown>" "mo3enc"
delete_bin "<unknown>" "unmo3"

### ts to mov ###
# Reason: Converts to mov files that only QuickTime Player (32-bits) can read IIRC
delete_bin "<unknown>" "ts2mov"

### QTCoffee ###
# Version: 1.2.5
# URL: http://web.archive.org/web/20150802051715/http://www.3am.pair.com/QTCoffee.html
# Reason: Uses QuickTime; 32-bits only
delete_bin "3amcoffee" "catmovie"
delete_bin "3amcoffee" "chapcutmovie"
delete_bin "3amcoffee" "modmovie"
delete_bin "3amcoffee" "muxmovie"
delete_bin "3amcoffee" "splitmovie"
delete_doc "3amcoffee" "doc/QTCoffee/How To.rtf"
delete_doc "3amcoffee" "doc/QTCoffee/License.rtf"
delete_doc "3amcoffee" "doc/QTCoffee/Read Me.rtf"
delete_doc "3amcoffee" "man/man1/catmovie.1"
delete_doc "3amcoffee" "man/man1/chapcutmovie.1"
delete_doc "3amcoffee" "man/man1/modmovie.1"
delete_doc "3amcoffee" "man/man1/muxmovie.1"
delete_doc "3amcoffee" "man/man1/QTCoffee.1"
delete_doc "3amcoffee" "man/man1/splitmovie.1"

# vim: ts=2 sw=2 et
