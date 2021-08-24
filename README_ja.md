# YT-DLP: Container Image

[English](README.md) / [Japanese](README_ja.md)

- This repository is inspired by [kijart/docker-youtube-dl](https://github.com/kijart/docker-youtube-dl).
- [Podman](https://github.com/containers/podman)と[Buildah](https://github.com/containers/buildah)での使用を前提として記載しています。Dockerをお使いの場合は適宜読み替えてください。

## 概要

- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** は、YouTube.comやその他いくつかのサイトからビデオをダウンロードするためのコマンドラインプログラムです。
- `yt-dlp` のコマンドラインのドキュメントは公式リポジトリを参照ください。 -> [options documentation](https://github.com/yt-dlp/yt-dlp#usage-and-options)

## コンテナイメージについて

コンテナイメージのビルド方式により下記の3種類があります
- `tnk4on/yt-dlp:latest,alpine-static` -> yt-dlpとFFmpegは静的バイナリを使用
- `tnk4on/yt-dlp:alpine-pip` -> パッケージ管理ツール(pip/apk)からyt-dlpとFFmpegを導入
- `tnk4on/yt-dlp:ubi8-minimal` -> パッケージ管理ツール(pip/dnf)からyt-dlpとFFmpegを導入

### 機能の特徴

- ベースイメージ:
    - python:alpine: `tnk4on/yt-dlp:latest,alpine-static,alpine-pip`
    - ubi8:ubi-minimal: `tnk4on/yt-dlp:ubi8-minimal`
- FFmpegインストール済み
- 非rootユーザーで実行。ユーザー: `yt-dlp` 作成済み。

## 使い方

### 基本コマンド

```
$ podman run --rm tnk4on/yt-dlp [OPTIONS] URL [URL...]
```
注釈：エントリーポイントは yt-dlp に設定されているので、引数に再度 yt-dlp を入れないでください。

### MP4動画の取得

1. ビデオとオーディオのフォーマットコードを確認

```
$ podman run --rm tnk4on/yt-dlp -F <url>
```

2. ホスト上に動画のダウンロード先をフォルダを作成し、ビデオとオーディオのフォーマットコード及びURLを指定して実行する

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

## 便利な使い方

### エイリアスコマンドを指定する

`.bashrc`にエイリアスを指定するとコマンド入力を省略できます

```
$ cat ~/.bashrc
...
alias yt-dlp="podman run --rm tnk4on/yt-dlp"
```

### `ENTORYPOINT`命令を使用せず、任意のコマンドを実行する

Sample 1 (FFmepgのバージョンを確認)

```
$ podman run --rm \--entrypoint "" tnk4on/yt-dlp ffmpeg -version |head -n1
ffmpeg version 4.4-static https://johnvansickle.com/ffmpeg/  Copyright (c) 2000-2021 the FFmpeg developers
```

Sample 2 (シェルを起動)

```
$ podman run --rm --entrypoint "" -it tnk4on/yt-dlp sh
/media $ 
```

## フォーマットを指定したMP4動画を作成する (yt-dlp-mp4.sh)

シェルスクリプトの引数にビデオとオーディオのフォーマットコード、URLを指定して実行するとMP4ファイルが出力されます。YouTube Studioの動画ダウンロード機能では720p(1280x720)の動画のみがダウンロードできるので、1080p(1920x1080)の動画を入手するのに利用できます。

### Setup

実行可能なパスにスクリプトをコピーし、実行権限を付与する

```
$ mkdir ~/bin
$ cp yt-dlp-mp4.sh ~/bin
$ chmod +x ~/bin/yt-dlp-mp4.sh
```

### Usage

1. `yt-dlp -F`を実行してビデオとオーディオのフォーマットを確認

```
$ yt-dlp -F <url>
```

2. ビデオ、オーディオ、ULRの順に引数を指定してスクリプトを実行

```
$ yt-dlp-mp4.sh 137 140 <url>
```

## コンテナイメージのビルド方法

### 静的バイナリを使用したコンテナイメージのビルド

```
$ git clone https://github.com/tnk4on/yt-dlp.git
$ cd yt-dlp/Containerfile.d
$ buildah bud -t tnk4on/yt-dlp .
```

### パッケージ管理ツール(pip/apk)を使ったコンテナイメージのビルド

```
$ git clone https://github.com/tnk4on/yt-dlp.git
$ cd yt-dlp/Containerfile.d
$ buildah bud -t tnk4on/yt-dlp:pip -f Containerfile.pip
```

### パッケージ管理ツール(pip/dnf)を使ったコンテナイメージのビルド

```
$ git clone https://github.com/tnk4on/yt-dlp.git
$ cd yt-dlp/Containerfile.d
$ buildah bud -t tnk4on/yt-dlp:ubi8-minimal -f Containerfile.ubi8-minimal
```