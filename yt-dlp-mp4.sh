#!/bin/sh

# $1: video
# $2: audio
# $3: YouTube URL
# $4: cookie
#$CMD -f $1+$2 --merge-output-format mp4 $4 $3

mkdir -p /tmp/yt-dlp;chmod o+w /tmp/yt-dlp
podman run --rm -v /tmp/yt-dlp:/media:Z --userns keep-id tnk4on/yt-dlp -f $1+$2 --merge-output-format mp4 $4 $3