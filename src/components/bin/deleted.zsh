######### Renamed #########

task__delete_bin "frizlab" "local_brew_install"
task__delete_bin "frizlab" "set_sound_volume"
task__delete_bin "frizlab" "get_mount_points"
task__delete_bin "frizlab" "is_desktop_picture"
task__delete_bin "frizlab" "merge_strings"
task__delete_bin "frizlab" "is_valid_jpeg"
task__delete_bin "frizlab" "backup_cloud"
task__delete_bin "frizlab" "GetTextEncoding"
task__delete_bin "frizlab" "brew_find_poured_from_bottle"
task__delete_bin "frizlab" "find_unreferenced_xcode_files"
task__delete_bin "ian.abbott" "ansi_colors"
task__delete_bin "frizlab" "abcm2pdf_runabc"
task__delete_bin "frizlab" "find_invalid_images"
task__delete_bin "frizlab" "import_to_photos"
task__delete_doc "frizlab" "import_to_photos/import_to_photos.scpt"
task__delete_bin "bbsteam" "bash_arrays"
task__delete_bin "frizlab" "ios_backup_to_files"
task__delete_bin "galloglass" "ls_mbdb"
task__delete_bin "frizlab" "check_itunes_artworks"
task__delete_bin "frizlab" "remove_xattr"
task__delete_bin "frizlab" "find_desktop_pictures"
task__delete_bin "frizlab" "launch_alarm_clock"
task__delete_bin "frizlab" "connect_netsoul"
task__delete_bin "frizlab" "persistent_netsoul"
task__delete_bin "frizlab" "fill_empty_dirs"
task__delete_bin "frizlab" "remove_quarantine"
task__delete_bin "frizlab" "make_link"
task__delete_bin "frizlab" "my_split"


######### Deleted #########

### Local Homebrew Install ###
# Reason: Replaced by a script to install homebrew unconditionally
task__delete_bin "frizlab" "local-brew-install"

### Xcode Project Version Manager ###
# Original author: Joachim Bondo
# Reason: Far better solutions exist on the Internet
task__delete_bin "frizlab" "xcode-project-version-manager"

### Find “Unreferenced” Files in an Xcode Project ###
# Reason: This tool can now be installed via Homebrew
task__delete_bin "frizlab" "find-unreferenced-xcode-files"

### Merge Xcode strings Files ###
# Original author was João Moreno but I rewrote pretty much everything.
# Reason: Obsoleted by LocMapper
task__delete_bin "frizlab" "merge-strings"

### Markdown Render Opener ###
# Reason: Not useful anymore; might re-create later if needed
task__delete_bin "frizlab" "markdown"

### Code Beautifier for C++ ###
# Version: 1.2
# Reason: 32-bits only; upstream could not be found
task__delete_bin "lingxiaofeng" "codebt"

### mo3 encoder and decoder ###
# Reason: 32-bits only; upstream could not be found; can most likely be replaced by ffmpeg
task__delete_bin "<unknown>" "mo3enc"
task__delete_bin "<unknown>" "unmo3"

### ts to mov ###
# Reason: Converts to mov files that only QuickTime Player (32-bits) can read IIRC
task__delete_bin "<unknown>" "ts2mov"

### QTCoffee ###
# Version: 1.2.5
# URL: http://web.archive.org/web/20150802051715/http://www.3am.pair.com/QTCoffee.html
# Reason: Uses QuickTime; 32-bits only
task__delete_bin "3amcoffee" "catmovie"
task__delete_bin "3amcoffee" "chapcutmovie"
task__delete_bin "3amcoffee" "modmovie"
task__delete_bin "3amcoffee" "muxmovie"
task__delete_bin "3amcoffee" "splitmovie"
task__delete_doc "3amcoffee" "doc/QTCoffee/How To.rtf"
task__delete_doc "3amcoffee" "doc/QTCoffee/License.rtf"
task__delete_doc "3amcoffee" "doc/QTCoffee/Read Me.rtf"
task__delete_doc "3amcoffee" "man/man1/catmovie.1"
task__delete_doc "3amcoffee" "man/man1/chapcutmovie.1"
task__delete_doc "3amcoffee" "man/man1/modmovie.1"
task__delete_doc "3amcoffee" "man/man1/muxmovie.1"
task__delete_doc "3amcoffee" "man/man1/QTCoffee.1"
task__delete_doc "3amcoffee" "man/man1/splitmovie.1"

# vim: ts=2 sw=2 et
