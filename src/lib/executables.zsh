# Binaries paths (this avoids rogue PATH fucking things up).

readonly CAT="/bin/cat"
readonly CHFLAGS="/usr/bin/chflags"
readonly CHMOD="/bin/chmod"
readonly CP="/bin/cp"
readonly DIFF="/usr/bin/diff"
readonly LN="/bin/ln"
readonly LS="/bin/ls"
readonly M4="/usr/bin/m4"
readonly MKDIR="/bin/mkdir"
readonly MV="/bin/mv"
readonly RM="/bin/rm"
readonly STAT="/usr/bin/stat"
readonly TAIL="/usr/bin/tail"


case "$HOST_OS" in
	"Darwin")
		readonly SED="/usr/bin/sed"
		readonly CHOWN="/usr/sbin/chown"
		readonly GREP="/usr/bin/grep"
		readonly READLINK="/usr/bin/readlink"
		readonly TAR="/usr/bin/tar"
	;;
	"Linux")
		readonly SED="/bin/sed"
		readonly CHOWN="/bin/chown"
		readonly GREP="/bin/grep"
		readonly READLINK="/bin/readlink"
		readonly TAR="/bin/tar"
		readonly LOCALE_GEN="/usr/sbin/locale-gen"
	;;
	*)
		print "Unknown host os $HOST_OS; don’t know basic utilities paths. Failing." >&2
		exit 1
	;;
esac
