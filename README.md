# YT-DLP: Container Image

Dowonload ---> [[Quay.io](https://quay.io/repository/tnk4on/yt-dlp): [![tnk4on/yt-dlp on Quay.io](https://quay.io/repository/tnk4on/yt-dlp/status "tnk4on/yt-dlp on Quay.io")](https://quay.io/repository/tnk4on/yt-dlp)] or [[Docker.io](https://hub.docker.com/r/tnk4on/yt-dlp)]

[English](README.md) / [Japanese](README_ja.md)

## Current Version: **2023.03.04**

- This repository is inspired by [kijart/docker-youtube-dl](https://github.com/kijart/docker-youtube-dl).
- This repository assumes the use of [Podman](https://github.com/containers/podman) and [Buildah](https://github.com/containers/buildah). If you are using Docker, please read as appropriate.

## Description

- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** is a command-line program to download videos from YouTube.com and a few more sites. 
-  For command line documentation of `yt-dlp`, please refer to the official repository. -> [options documentation](https://github.com/yt-dlp/yt-dlp#usage-and-options)

## About container images

There are three types of container images depending on how they are built
- `tnk4on/yt-dlp:latest,alpine-static` -> static binaries are used for yt-dlp and FFmpeg
- `tnk4on/yt-dlp:alpine-pip` -> install yt-dlp and FFmpeg from package management tool (pip/apk)
- `tnk4on/yt-dlp:ubi-minimal` -> install yt-dlp and FFmpeg from package management tool (pip/dnf)

### Features

- Base Image: 
    - python:alpine: `tnk4on/yt-dlp:latest,alpine-static,alpine-pip`
    - ubi8:ubi-minimal: `tnk4on/yt-dlp:ubi-minimal`
- [FFmpeg](https://johnvansickle.com/ffmpeg/) already installed
    - FFmpeg Static Builds: `release:6.0`
- Run as a non-root user. User: `yt-dlp` Created.

## How to use

### Basic commands

```
$ podman run --rm tnk4on/yt-dlp [OPTIONS] URL [URL...]
```
Note: The entrypoint is set to yt-dlp, so do not put yt-dlp again as argument.

### Get MP4 video

1. Check video and audio format code

```
$ podman run --rm tnk4on/yt-dlp -F <url>
```

2. Create a folder to download the video on the host, specify the format code and URL of the video and audio, and execute it.

```
$ mkdir -p /tmp/yt-dlp;chmod o+w /tmp/yt-dlp
$ VIDEO=137
$ AUDIO=140
$ URL=<url>
$ podman run --rm \
    -v /tmp/yt-dlp:/media:Z \
    --userns keep-id \
    tnk4on/yt-dlp \
    -f ${VIDEO}+${AUDIO} --merge-output-format mp4 ${URL}
```

## Advanced usage

### Specify an alias command

`.bashrc` You can omit command input by specifying an alias for

```
$ cat ~/.bashrc
...
alias yt-dlp="podman run --rm tnk4on/yt-dlp"
```

### `ENTORYPOINT` Execute arbitrary command without using instructions

Sample 1 (Check the version of FFmepg)

```
$ podman run --rm \--entrypoint "" tnk4on/yt-dlp ffmpeg -version |head -n1
ffmpeg version 4.4.1-static https://johnvansickle.com/ffmpeg/  Copyright (c) 2000-2021 the FFmpeg developers
```

Sample 2 (launch a shell)

```
$ podman run --rm --entrypoint "" -it tnk4on/yt-dlp sh
/media $ 
```

## Create an MP4 video with a specified format (yt-dlp-mp4.sh)

If you specify the video and audio format code and URL in the argument of the shell script and execute it, an MP4 file will be output. YouTube Studio's video download feature can only download 720p (1280x720) videos, so you can use it to get 1080p (1920x1080) videos.

### Setup

Copy the script to an executable path and grant execute permission

```
$ mkdir ~/bin
$ cp yt-dlp-mp4.sh ~/bin
$ chmod +x ~/bin/yt-dlp-mp4.sh
```

### Usage

1. `yt-dlp -F` To check the video and audio formats

```
$ yt-dlp -F <url>
```

2. Run the script with arguments in the order of video, audio, URL

```
$ yt-dlp-mp4.sh 137 140 <url>
```

## How to build the container image

###  Build a container image for static binaries

```
$ git clone https://github.com/tnk4on/yt-dlp.git
$ cd yt-dlp/Containerfile.d
$ buildah bud -t tnk4on/yt-dlp .
```

### Build a container image with package management tool (pip/apk)

```
$ git clone https://github.com/tnk4on/yt-dlp.git
$ cd yt-dlp/Containerfile.d
$ buildah bud -t tnk4on/yt-dlp:pip -f Containerfile.pip
```

### Build a container image with package management tool (pip/dnf)

```
$ git clone https://github.com/tnk4on/yt-dlp.git
$ cd yt-dlp/Containerfile.d
$ buildah bud -t tnk4on/yt-dlp:ubi8-minimal -f Containerfile.ubi8-minimal
```