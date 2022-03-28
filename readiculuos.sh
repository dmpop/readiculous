#!/usr/bin/env bash
if [ ! -x "$(command -v convert)" ] || [ ! -x "$(command -v pandoc)" ] || [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v awk)" ]; then
    echo "Make sure that the required tools are installed"
    exit 1
fi

# Usage prompt
usage() {
    cat <<EOF
$0 [OPTIONS]
------
$0 transforms web pages pages into readable EPUB files.

USAGE:
------
  $0 -u <URL> -d <dir>

OPTIONS:
--------
  -u Specifies the source URL
  -t Specifies a title of the output file
  -d Destination directory
EOF
    exit 1
}

while getopts "u:d:" opt; do
    case ${opt} in
    u)
        url=$OPTARG
        ;;
    d)
        dir=$OPTARG
        ;;
    \?)
        usage
        ;;
    esac
done
shift $((OPTIND - 1))

if [ -z "$url" ] || [ -z "$dir" ]; then
    usage
fi

dir=Library/"$dir"
mkdir -p "$dir"
title=$(curl -s $url | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}')
./go-readability $url >>"$dir/$title".html

r=$(shuf -i 0-255 -n 1)
g=$(shuf -i 0-255 -n 1)
b=$(shuf -i 0-255 -n 1)

convert -size 1000x1000 xc:rgb\($r,$g,$b\) cover.png
convert -background '#0008' -font Open-Sans -pointsize 50 -fill white -gravity center -size 1000x150 caption:"$title" cover.png +swap -gravity center -composite cover.png

for f in fonts/*.ttf; do
    embed_fonts+="--epub-embed-font="
    embed_fonts+=$f
    embed_fonts+=" "
done

pandoc -f html -t epub --metadata title="$title" --metadata creator="Readiculous" --metadata publisher="$url" --css=stylesheet.css $embed_fonts --epub-cover-image=cover.png -o "$dir/$title".epub "$dir/$title".html

rm cover.png
