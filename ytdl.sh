#!/bin/env /bin/bash


songs=${1-"a0yo-Ywpxis"}
ytdl=`which youtube-dl`
fmt=${2-"mp3"}

if [[ -x "${ytdl}" ]]; then
  for song in "${songs}"; do
    "${ytdl}" --extract-audio --audio-format "${fmt}" --prefer-ffmpeg  https://www.youtube.com/watch?v="${song}"
  done
else
  printf "No youtube-dl executable found in path\n"
fi
