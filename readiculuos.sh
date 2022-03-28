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
  $0 -u <URL> -d <dir> -m auto

OPTIONS:
--------
  -u Source URL
  -d Destination directory
  -m Enable auto mode

EXAMPLES:
---------
$0 -u https://psyche.co/guides/how-to-approach-the-lifelong-project-of-language-learning -d "Language"
$0 -m auto

EOF
    exit 1
}

#Read the specfied parameters
while getopts "u:d:m:" opt; do
    case ${opt} in
    u)
        url=$OPTARG
        ;;
    d)
        dir=$OPTARG
        ;;
    m)
        mode=$OPTARG
        ;;
    \?)
        usage
        ;;
    esac
done
shift $((OPTIND - 1))

# Generate random RBG values for cover color
r=$(shuf -i 0-255 -n 1)
g=$(shuf -i 0-255 -n 1)
b=$(shuf -i 0-255 -n 1)

# Add all fonts
for f in fonts/*.ttf; do
    embed_fonts+="--epub-embed-font="
    embed_fonts+=$f
    embed_fonts+=" "
done

# If "-m auto" is specified
if [ "$mode" = "auto" ]; then
    file="links.txt"
    if [ ! -f "$file" ]; then
        echo "$file not found."
        exit 1
    fi
    dir="Library"
    mkdir -p "$dir"
    # Read the contents of the links.txt file line-by-line
    while IFS="" read -r url || [ -n "$url" ]; do
        # For each URL, extract <title>
        title=$(curl -s $url | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}')
        # generate a readable HTML file
        ./go-readability $url >>"$dir/$title".html
        # generate a cover
        convert -size 1000x1000 xc:rgb\($r,$g,$b\) cover.png
        convert -background '#0008' -font Open-Sans -pointsize 50 -fill white -gravity center -size 1000x150 caption:"$title" cover.png +swap -gravity center -composite cover.png
        # convert HTML to EPUB
        pandoc -f html -t epub --metadata title="$title" --metadata creator="Readiculous" --metadata publisher="$url" --css=stylesheet.css $embed_fonts --epub-cover-image=cover.png -o "$dir/$title".epub "$dir/$title".html
        rm cover.png
    done <"$file"
    exit 1
fi

if [ -z "$url" ] || [ -z "$dir" ]; then
    usage
fi

dir=Library/"$dir"
mkdir -p "$dir"

# Extract <title> from the specified URL
title=$(curl -s $url | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}')
# Generate a readable HTML file
./go-readability $url >>"$dir/$title".html
# generate a cover
convert -size 1000x1000 xc:rgb\($r,$g,$b\) cover.png
convert -background '#0008' -font Open-Sans -pointsize 50 -fill white -gravity center -size 1000x150 caption:"$title" cover.png +swap -gravity center -composite cover.png
# convert HTML to EPUB
pandoc -f html -t epub --metadata title="$title" --metadata creator="Readiculous" --metadata publisher="$url" --css=stylesheet.css $embed_fonts --epub-cover-image=cover.png -o "$dir/$title".epub "$dir/$title".html

rm cover.png
