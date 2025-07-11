#!/bin/bash
set -e

input_file="$1"

multiply="${2:-1.5}"

if [ -z "$input_file" ]; then
  echo "Usage: $0 input/filename.png"
  exit 1
fi

filename_only=$(basename "$input_file")
name_no_ext="${filename_only%.*}"

container_input="input/${filename_only}"
container_output="output/${name_no_ext}-bright.png"
icc_profile="2020_profile.icc"

docker compose run --rm imagemagick \
  "$container_input" \
  -define quantum:format=floating-point \
  -colorspace RGB \
  -auto-gamma \
  -evaluate Multiply $multiply \
  -evaluate Pow 0.9 \
  -colorspace sRGB \
  -depth 16 \
  -profile "$icc_profile" \
  "$container_output"
