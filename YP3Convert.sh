#!/bin/bash

echo "thanks for using my tool! please subscribe to my channel and please contribute! https://www.youtube.com/@omer5090Ti?app=desktop"
if [ -z "$1" ]; then
    echo "Usage: ./YP3Convert.sh <video.mp4>"
    exit 1
fi

input_file="$1"

filename=$(basename -- "$input_file")
base_name="${filename%.*}"
output_dir="$base_name"

if [ -d "$output_dir" ]; then
    echo "Removing old folder: '$output_dir/'"
    rm -rf "$output_dir"
fi
mkdir -p "$output_dir"

output_pattern="${output_dir}/%02d.avi"

echo "Converting and splitting '$input_file' into 170-Second chunks..."

ffmpeg -i "$input_file" \
    -vf "scale=160:128, transpose=2, vflip" \
    -r 16 \
    -pix_fmt yuvj420p \
    -c:v mjpeg \
    -vtag MJPG \
    -q:v 2 \
    -acodec pcm_s16le \
    -ac 2 \
    -ar 22050 \
    -f segment \
    -segment_time 170 \
    -reset_timestamps 1 \
    "$output_pattern"

echo "Success! All parts saved inside: '$output_dir/'"
