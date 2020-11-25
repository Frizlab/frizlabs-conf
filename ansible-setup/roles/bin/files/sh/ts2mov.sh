#!/bin/sh

red="\033[1;31m"
green="\033[1;31m"
color_end="\033[0m"

usage() {
	echo "Usage: $0 inputfile fps outputfile [audio_stream_id]" >/dev/stderr
	echo "  audio_stream_id is an integer starting at 1. Default is 1." >/dev/stderr
	exit 1
}

print_err() {
	echo "$0: $red$1$color_end" >/dev/stderr
}

if [ "$#" -ne 3 -a "$#" -ne 4 ]; then
	usage $0
fi

filename="$1"
fps="$2"
outputfile="$3"
audio_stream_id="$4"

if [ -z "$audio_stream_id" ]; then audio_stream_id=1; fi

if [ ! -f "$filename" ]; then
	print_err "$filename: no such file"
	exit 2
fi

if [ -f "$outputfile".mkv ]; then
	print_err "Cannot run: a file named \"$outputfile.mkv\" exists"
	exit 2
fi

audiofile="`mktemp audiopart.XXXX`"
if [ "$?" -ne 0 ]; then
	print_err "Cannot create temporary file. Exiting, nothing is done."
	exit 3
fi
rm "$audiofile"

videofile="`mktemp videopart.XXXX`"
if [ "$?" -ne 0 ]; then
	print_err "Cannot create temporary file. Exiting, nothing is done."
	exit 3
fi
rm "$videofile"

ffmpeg -i "$filename" -vcodec copy -f h264 "$videofile" -map 0:"$audio_stream_id" -acodec copy -f ac3 "$audiofile"
if [ "$?" -ne 0 ]; then
	rm -f "$videofile"
	rm -f "$audiofile"
	echo ""
	print_err "ffmpeg error while demuxing input file. Exiting, nothing is done."
	exit 4
fi

mkvmerge "$audiofile" --default-duration 0:${fps}fps "$videofile" -o "$outputfile".mkv
if [ "$?" -ne 0 ]; then
	rm -f "$videofile"
	rm -f "$audiofile"
	echo ""
	print_err "mkvmerge error while joining streams. Exiting. All output has been cleaned."
	exit 5
fi

rm -f "$videofile" "$audiofile"

modmovie -self-contained "$outputfile".mkv -o "$outputfile"
if [ "$?" -ne 0 ]; then
	rm -f "$outputfile"
	echo ""
	print_err "modmovie error while converting mkv to mov. Exiting. The mkv file has been kept."
	exit 6
fi

rm -f "$outputfile".mkv

echo ""
echo "${green}Conversion finished.$color_end"
echo "Please check the resulting file, it may not be correct. Indeed, many assumptions are made in this script, such as the video and audio format of the (m2)ts file..."
