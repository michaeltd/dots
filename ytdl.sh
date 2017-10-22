#!/usr/bin/env /bin/bash

set -aeu

# lilly allen 
#songs="fUYaosyR4bE 0WxDrVUrSvI q-wGMlSuX_c wmYT79tPvLg tWjNFC-FinU -RgOm_WJKpE E0CazRHB0so o8VZX4sHn-4 mer6X7nOY_o vo9Fja5x04o 3jOzuLsJIUE FbDMUijBP2U 9kPQiAJv4fo pfACIxjsuu0 gw9wE1nutc4 1JFvOhRrHn0 lDlofPAOZy0 nu905oeqrOg utg9Oe1Frqc 5DuVt1k8bdM 5u6HhbqAgwc Sv4N3zAvl4I tQeae9z6gSk zWJP7F-azlo uEiKpVcp3zg NkoRBRjoZxs MGL5EtYGGDM ii3XMEVUhhM ZZC5XMjAMzo"
# lady gaga 
#songs="bESGLojNYSo qrO4YZeyl0I d2smz_1L2_0 2Abk1jAONjw niqrrmev4mA 1mB0tP1I-14 wV1FrqwZyKw wagn8Wrmzuc pco91kroVgQ QeWBS0JBNzQ Xn599R0ZBwg en2D_5TzXCA X9YMU0WeBwU 7Nr33m1zXVE vp8VZe5kqEM GQ95z6ywcBY o9iQ8lIfyEs _7HvURBhMGE ohs0a-QnFF4 Okq8xHrIZ8I VFwmKL5OL-Q fHGKG9dyTKI ZmWBrN7QV6Y"
# Daft Punk
#songs="5NV6Rdv1a3I a5uQMwRMHcs NF-kLy44Hls L93-7vRfxNs yca6UsllwYs bRt5z880CFY YtdWHFwmd2o IluRBvnYMoY HoQN7K6HdRw LL-gyhZVvx0 m4cgLL8JaVI xBTqRd09y3E ajGKWk0auOc zhl-Cs1-sG4 Q5l2ChAqRDg 0Gkhol2Q1og _ScM9pKlCfo uURB-vo9rZ4 3T0NqvdUiWI JI5noh4OyXc QOngRDVtEQI wz7YiQdNmZ8"
# Jamiroquai
#songs="4JkIs37a2JE D-NvQ6VJYtE 1hHSH9sJUEo OEcBz6VtyDg vE4VlA_9OrI FRSH-egVyzk OPkjnRIdQXQ oMk1wBPiUIo WIUAC03YMlA 9kXiLeBXzG4 LHj_WC_IzFc fVMtKQMAZqw H9W9rc-P9UQ mjeWKssl8Ic uldpc4rWNXQ MVTkbCCl3-I 7yUq1-BRlPE Dg7E9wEQVOA eo7iwlMFPrM Nb6EFh8HlV4 w4AQbsCz1AY GkL7cVqIZHU"
# BF
#songs="3DcEMdNbZM4 osHVy_038jw sya1CzmsvLc ZyvwODEjmXw IPMnEmkoPFs KDRRxRm6BmI"
# Bob Marley
#songs=( CHekNnySAfM vdB-8eLEW8g S5FCdx7Dn0o LanCLS_hIo4 Mm7muPjevik oFRbZJXjWIA -JhwxTen6yA S3UqvWk8-uw 2XiYUYcpsT4 x59kS2AOrGM L3HQMbQAWRc R8GCc8OhTz8 H5Qda2HS7X0 8WQVb_nuKvs gODh1nsHlPg QrY9eHkXTa4 yLuHE-82o40 QMS5vKarzO0 QQQpkll5aoA on9TXY8kYyk )

fmt="mp3"

ytdl=$(which youtube-dl)

if [[ -x "${ytdl}" ]]; then
  for song in "${songs[@]}"; do
    "${ytdl}" --extract-audio --audio-format "${fmt}" --prefer-ffmpeg https://www.youtube.com/watch?v="${song}"
  done
else
  printf "No youtube-dl executable found in path\n"
fi
