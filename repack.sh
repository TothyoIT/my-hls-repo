#!/usr/bin/env bash
# repack.sh
set -e

# Input HLS URL and output directory
INPUT_URL="https://d1e7rcqq4o2ma.cloudfront.net/bpk-tv/1709/output/1709.m3u8"
OUT_DIR="docs"

# Fresh start
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

echo "Starting FFmpeg in live-event mode…"
ffmpeg -hide_banner -loglevel warning -i "$INPUT_URL" \
  -c copy \
  -f hls \
  -hls_time 10 \
  -hls_list_size 0 \            # 0 means keep all segments
  -hls_wrap 0 \                 # no wrapping
  -start_number 0 \
  -hls_playlist_type event \    # event mode keeps full history
  -hls_flags append_list \      # append new segments without deleting old
  -hls_segment_filename "$OUT_DIR/chunk_%03d.ts" \
  "$OUT_DIR/playlist.m3u8" || true

# Copy custom player page into docs/
if [ -f /work/index.html ]; then
  cp /work/index.html "$OUT_DIR/index.html"
fi

# Update timestamp to force git changes
date -u +"%Y-%m-%dT%H:%M:%SZ" > "$OUT_DIR/timestamp.txt"
