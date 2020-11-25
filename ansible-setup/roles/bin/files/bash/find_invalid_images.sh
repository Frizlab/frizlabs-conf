#!/bin/bash

# If the second argument is present and set to 0, the script outputs the invalid
# images separated by a "\0" instead of "\n" in order to be ready to be inputed
# to xargs -0
if [ $# -ne 1 -a $# -ne 2 ]; then echo "Usage: $0 folder [0]" >/dev/stderr; exit 42; fi

end='-exec echo \;'
if [ "$2" = "0" ]; then
	tmp=$(mktemp -t $$)
	echo "AA==" >$tmp
	end='-exec base64 -D -i $tmp \;'
fi
eval find "\"$1\"" -type f ! -exec ~/bin/is_valid_jpeg.sh {} \\\; -exec echo -n {} \\\; $end
if [ "$2" = "0" ]; then rm $tmp; fi
