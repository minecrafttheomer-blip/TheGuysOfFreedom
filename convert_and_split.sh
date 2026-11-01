#!/bin/bash

# Check if an input file was provided
if [ -z "$1" ]; then
    echo "Usage: ./convert_and_split.sh <video.mp4>"
    exit 1
fi

input_file="$1"

# Extract filename without path and extension
filename=$(basename -- "$input_file")
base_name="${filename%.*}"
output_dir="$base_name"

# Remove old folder if it already exists, then create a fresh one
if [ -d "$output_dir" ]; then
    echo "Removing old folder: '$output_dir/'"
    rm -rf "$output_dir"
fi
mkdir -p "$output_dir"

# Define output pattern (e.g., folder_name/01.avi, folder_name/02.avi)
output_pattern="${output_dir}/%02d.avi"

echo "Converting and splitting '$input_file' into 3-minute chunks..."

# Run your custom FFmpeg command with the segment muxer
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
    -segment_time 180 \
    -reset_timestamps 1 \
    "$output_pattern"

echo "Success! All parts saved inside: '$output_dir/'"