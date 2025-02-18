#!/bin/bash

[[ "${1}" =~ ^[[:digit:]]+$ ]] || exit

sNumber="$1"
sDB=/var/local/spines/spinesdb.txt
sMusic=/mnt/Music/
sW=65
sH=1180

[[ -r /etc/spines.conf ]] && . /etc/spines.conf

IFS=\| read sId sPath sDate sReleaseType sArtist sYear sAlbum <<< $(grep -e "^${sNumber}|" "${sDB}")
sPathx="${sMusic}/${sPath%/*}"

sImg=$(ls "${sPathx}/spine.jpg" "${sPathx}/spine.png"|head -1)

if [[ -r "${sImg}" ]]
then
  sLen=$(stat --printf "%s" "${sImg}")
  echo "Content-type: image/${sImg##*.}"
  echo "Content-length: ${sLen}"
  echo ""
  [[ -n "$HTTP_USER_AGENT" ]] && cat "${sImg}"
  #cat "${sImg}"
else #make an image SVG
  sText="${sArtist} - ${sAlbum}"
  [[ -z "${sArtist}" ]] && sText="${sAlbum}"
  sSVG="<svg version=\"1.1\" width=\"${sW}\" height=\"${sH}\" xmlns=\"http://www.w3.org/2000/svg\">"
  sSVG="${sSVG}<rect width=\"100%\" height=\"100%\" fill=\"gainsboro\" />"
  sSVG="${sSVG}<text font-size=\"$((sW*10/15))\" text-anchor=\"middle\" transform=\"translate($((sW/2)),$((sH/2))) rotate(90)\">${sText}</text>"
  sSVG="${sSVG}</svg>"
  echo "Content-type: image/svg+xml"
  echo "Content-length: ${#sSVG}"
  echo ""
  echo "${sSVG}"
fi
