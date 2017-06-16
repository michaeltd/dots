#!/bin/sh

URL='http://www.accuweather.com/en/gr/athens/182536/weather-forecast/182536'

wget -q -O- "$URL" | awk -F\' '/acm_RecentLocationsCarousel\.push/{print $2": "$16", "$12"°" }'| head -1
