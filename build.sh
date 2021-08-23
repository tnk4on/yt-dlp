#!/bin/bash

podman login docker.io
CURDIR=$PWD
cd Containerfile.d

# Building Image
buildah bud -t yt-dlp -f Containerfile
buildah bud -t yt-dlp:pip -f Containerfile.pip
buildah bud -t yt-dlp:ubi8-minimal -f Containerfile.ubi8-minimal

# Test
podman run --rm yt-dlp --version
podman run --rm yt-dlp:pip --version
podman run --rm yt-dlp:ubi8-minimal --version

# Push
podman push yt-dlp docker.io/tnk4on/yt-dlp --format v2s2
podman push yt-dlp docker.io/tnk4on/yt-dlp:static --format v2s2
podman push yt-dlp:pip docker.io/tnk4on/yt-dlp:pip --format v2s2
podman push yt-dlp:ubi8-minimal docker.io/tnk4on/yt-dlp:ubi8-minimal --format v2s2

cd $CURDIR