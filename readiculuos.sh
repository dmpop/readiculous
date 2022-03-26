#!/usr/bin/env bash
if [ ! -x "$(command -v convert)" ] || [ ! -x "$(command -v pandoc)" ]; then
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
  $0 -u <URL> -t <title>

OPTIONS:
--------
  -u Specifies the source URL
  -t Specifies a title of the output file
EOF
    exit 1
}

while getopts "u:t:c:" opt; do
    case ${opt} in
    u)
        url=$OPTARG
        ;;
    t)
        title=$OPTARG
        ;;
    \?)
        usage
        ;;
    esac
done
shift $((OPTIND - 1))

r=$(shuf -i 0-255 -n 1)
g=$(shuf -i 0-255 -n 1)
b=$(shuf -i 0-255 -n 1)

convert -size 1000x1000 xc:rgb\($r,$g,$b\) cover.png
convert -background '#0008' -font Open-Sans -pointsize 50 -fill white -gravity center -size 1000x150 caption:"$title" cover.png +swap -gravity center -composite cover.png

./go-readability $url >>"$title".html

for f in fonts/*.ttf; do
    embed_fonts+="--epub-embed-font="
    embed_fonts+=$f
    embed_fonts+=" "
done

pandoc -f html -t epub --metadata title="$title" --metadata creator="Readiculous" --metadata publisher="$url" --css=stylesheet.css $embed_fonts --epub-cover-image=cover.png -o "$title".epub "$title".html
rm cover.png "$title".html
