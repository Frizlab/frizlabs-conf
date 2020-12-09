#!/bin/sh
#
# colors v1.03
#
# A simple shell script to output an ANSI terminal color chart.
# It may be useful when trying to customize your ANSI terminal
# color scheme!
#
# Written and placed in the public domain by Ian Abbott <ian@abbott.org>
#

for h in 0 1; do
	echo "\\033[0;${h}m\\c"
	case $h in
		0) echo "Normal\\c";;
		1) echo "High\\c";;
	esac
	echo " intensity foreground (background color in parentheses)\\033[m"
	for f in 0 1 2 3 4 5 6 7; do
		for b in 0 1 2 3 4 5 6 7 8; do
			echo "\\033[${h};3${f}\\c"
			if [ $b -lt 8 ]; then
				echo ";4${b}m\\c"
			else
				echo "m\\c"
			fi
			case $f in
				0) echo " BLACK \\c";;
				1) echo "  RED  \\c";;
				2) echo " GREEN \\c";;
				3) echo " YELLOW\\c";;
				4) echo "  BLUE \\c";;
				5) echo "MAGENTA\\c";;
				6) echo "  CYAN \\c";;
				7) echo " WHITE \\c";;
			esac
			case $b in
				8) echo "\\033[m";;
				*) echo " \\033[m \\c";;
			esac
		done
	done
	echo "\\033[${h}m\\c"
	for b in 0 1 2 3 4 5 6 7 8; do
		case $b in
			0) echo "(black)  \\c";;
			1) echo " (red)   \\c";;
			2) echo "(green)  \\c";;
			3) echo "(yellow) \\c";;
			4) echo " (blue)  \\c";;
			5) echo "(magenta)\\c";;
			6) echo " (cyan)  \\c";;
			7) echo "(white)  \\c";;
			8) echo " (none)\\c";;
		esac
	done
	echo "\\033[m\\n"
done

exit

export LS_COLORS='ex=36:di=32:*.f=33:*.F=33:*.c=33:*.h=33:ln=43;34:or=43;31'

	no       0       Normal (non-filename) text
	fi       0       Regular file
	di       32      Directory
	ln       36      Symbolic link
	pi       31      Named pipe (FIFO)
	so       33      Socket
	bd       44;37   Block device
	cd       44;37   Character device
	ex       35      Executable file
	mi       (none)  Missing file (defaults to fi)
	or       (none)  Orphanned symbolic link (defaults to ln)
	lc       \e[     Left code
	rc       m       Right code
	ec       (none)  End code (replaces lc+no+rc)

	"*.c=34"

	Control characters : C-like \- escaped notation
	                     stty-like ^-notation
\e for Escape
\_ for a normal space
\? for Delete
\\, \^, \: (override)

	<lc> <color code> <rc> <filename> <ec>
	<ec> undef : on prend <lc> <no> <rc>

             0     to restore default color
             1     for brighter colors
             4     for underlined text
             5     for flashing text
				 
            30     for black foreground
            31     for red foreground
            32     for green foreground
            33     for yellow (or brown) foreground
            34     for blue foreground
            35     for purple foreground
            36     for cyan foreground
            37     for white (or gray) foreground

            40     for black background
            41     for red background
            42     for green background
            43     for yellow (or brown) background
            44     for blue background
            45     for purple background
            46     for cyan background
            47     for white (or gray) background
