#!/bin/sh

die() {
  echo "$@"
  exit 1
}

NVENC() {
	pngfile="$1"
	output="$2"
	format="$3"
	case $format in
	DXT1)
		nvcompress -nocuda -bc1 "$pngfile" "$output"
		;;
	DXT3)
		nvcompress -nocuda -bc2 "$pngfile" "$output"
		break
		;;
	DXT5)
		nvcompress -nocuda -bc3 "$pngfile" "$output"
		break
		;;
	*)
		echo "Unsupported format: $format"
		;;
  esac
	rm "$pngfile"
}

S2TC() {
	export S2TC_COLORDIST_MODE=SRGB_MIXED
	export S2TC_RANDOM_COLORS=64
	export S2TC_REFINE_COLORS=LOOP
	export S2TC_DITHER_MODE=FLOYDSTEINBERG
	pngfile="$1"
	tgafile="$(mktemp --suffix=.tga)"
	convert "$pngfile" "$tgafile"
	case "$3" in
DXT1|DXT3|DXT5)
	s2tc_compress -i "$tgafile" -o "$2" -t "$3"
;;
*)
	echo "Unsupported format: $3"
;;
  esac
	rm "$pngfile"
	rm "$tgafile"
}

[ $# -lt 7 ] && die "Usage: $(basename "$0") NVENC|S2TC <r> <g> <b> <output.dds> <width> <height> <DXT1|DXT3|DXT5>"

method="$1"
shift
r="$1"
shift
g="$1"
shift
b="$1"
shift
output="$1"
shift
width="$1"
shift
height="$1"
shift
format="$1"
pngfile="$(mktemp --suffix=.png)"

convert -size $width'x'$height xc:"rgb($r,$g,$b)" "$pngfile"
case "$method" in
NVENC|S2TC)
	$method "$pngfile" "$output" "$format"
;;
*)
  die "Unsupported format: $method"
;;
esac
