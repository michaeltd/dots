#!/bin/env /bin/bash

#declare -a songs
# lilly allen songs="fUYaosyR4bE 0WxDrVUrSvI q-wGMlSuX_c wmYT79tPvLg tWjNFC-FinU -RgOm_WJKpE E0CazRHB0so o8VZX4sHn-4 mer6X7nOY_o vo9Fja5x04o 3jOzuLsJIUE FbDMUijBP2U 9kPQiAJv4fo pfACIxjsuu0 gw9wE1nutc4 1JFvOhRrHn0 lDlofPAOZy0 nu905oeqrOg utg9Oe1Frqc 5DuVt1k8bdM 5u6HhbqAgwc Sv4N3zAvl4I tQeae9z6gSk zWJP7F-azlo uEiKpVcp3zg NkoRBRjoZxs MGL5EtYGGDM ii3XMEVUhhM ZZC5XMjAMzo"

# lady gaga 
songs="bESGLojNYSo qrO4YZeyl0I d2smz_1L2_0 2Abk1jAONjw niqrrmev4mA 1mB0tP1I-14 wV1FrqwZyKw wagn8Wrmzuc pco91kroVgQ QeWBS0JBNzQ Xn599R0ZBwg en2D_5TzXCA X9YMU0WeBwU 7Nr33m1zXVE vp8VZe5kqEM GQ95z6ywcBY o9iQ8lIfyEs _7HvURBhMGE ohs0a-QnFF4 Okq8xHrIZ8I VFwmKL5OL-Q fHGKG9dyTKI ZmWBrN7QV6Y"

fmt="mp3"

ytdl=$(which youtube-dl)

#if [[ -x "${ytdl}" ]]; then
for song in ${songs} ; do
  "${ytdl}" --extract-audio --audio-format ${fmt} --prefer-ffmpeg https://www.youtube.com/watch?v=${song}
done
#else
#  printf "No youtube-dl executable found in path\n"
#fi
