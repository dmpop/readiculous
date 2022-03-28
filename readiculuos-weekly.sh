#!/usr/bin/env bash
if [ ! -x "$(command -v convert)" ] || [ ! -x "$(command -v pandoc)" ] || [ ! -x "$(command -v wget)" ] || [ ! -x "$(command -v awk)" ]; then
    echo "Make sure that the required tools are installed"
    exit 1
fi

file="links.txt"
date=$(date +%Y-%U)
dir="Library/$date"
mkdir -p "$dir"

for f in fonts/*.ttf; do
    embed_fonts+="--epub-embed-font="
    embed_fonts+=$f
    embed_fonts+=" "
done

while IFS="" read -r url || [ -n "$url" ]; do
    wget -q $url -O tmp.html
    title=$(awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}' tmp.html)
    ./go-readability $url >>"$dir/$title".html
    r=$(shuf -i 0-255 -n 1)
    g=$(shuf -i 0-255 -n 1)
    b=$(shuf -i 0-255 -n 1)
    convert -size 1000x1000 xc:rgb\($r,$g,$b\) cover.png
    convert -background '#0008' -font Open-Sans -pointsize 50 -fill white -gravity center -size 1000x150 caption:"$title" cover.png +swap -gravity center -composite cover.png
    pandoc -f html -t epub --metadata title="$title" --metadata creator="Readiculous" --metadata publisher="$url" --css=stylesheet.css $embed_fonts --epub-cover-image=cover.png -o "$dir/$title".epub "$dir/$title".html
    rm tmp.html
    rm cover.png
done <"$file"
