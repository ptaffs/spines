#!/bin/bash
sComma="{"

echo "Content-type: application/json;"
echo ""
echo "{\"playlist\": ["
echo "playlistinfo" | socat - UNIX-CONNECT:/run/mpd/socket |
grep -v "^OK" |
while read sPair
do
  #echo "${sComma}\"${sPair%%:*}\": \"${sPair##*: }\""
  sTag="${sPair%%:*}"
  sValue="${sPair##*: }"
  echo "${sComma}\"${sTag}\": \"${sValue//\"/\\\"}\""
  sComma=","
  if [[ "${sPair%%:*}" = "Id" ]]
  then
    sComma=",{"
    echo "}"
  fi
done
echo "]}"
#peter@tinybee:~$ echo "playlistinfo" | socat - UNIX-CONNECT:/run/mpd/socket
#OK MPD 0.22.4
#file: //mnt/Music///Albums/Natalie Prass/Natalie Prass 2018 The Future and the Past/01.Oh_My.flac
#Last-Modified: 2023-01-04T23:17:41Z
#Artist: Natalie Prass
#Album: The Future and the Past
#Title: Oh My
#Date: 2018
#Track: 1
#Time: 196
#duration: 196.000
#Pos: 0
#Id: 2427
