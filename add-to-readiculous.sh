#!/usr/bin/env bash
url=$(xclip -o)
echo $url
cd /home/dmpop/Documents/readiculuos
./readiculuos.sh -u $url
notify-send "Added to Readiculous"