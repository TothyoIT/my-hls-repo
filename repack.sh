#!/usr/bin/env bash
set -e

# Input HLS URL and output directory
INPUT_URL="https://d1e7rcqq4o2ma.cloudfront.net/bpk-tv/1709/output/1709.m3u8"
OUT_DIR="docs"

# Fresh start
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

echo "Starting FFmpeg (up to 50s, timeout)…"
# Run for up to 50s, ignore non-zero exit (timeout)
timeout 50s ffmpeg -hide_banner -loglevel warning -i "$INPUT_URL" \
  -c copy \
  -f hls \
  -hls_time 10 \
  -hls_list_size 7 \
  -hls_wrap 7 \
  -start_number 0 \
  -hls_flags delete_segments \
  -hls_segment_filename "$OUT_DIR/chunk_%03d.ts" \
  "$OUT_DIR/playlist.m3u8" || true

# Copy your custom player page into docs/
if [ -f /work/index.html ]; then
  cp /work/index.html "$OUT_DIR/index.html"
fi

# Update timestamp to force git changes
date -u +"%Y-%m-%dT%H:%M:%SZ" > "$OUT_DIR/timestamp.txt"
