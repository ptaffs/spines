#!/bin/bash


[[ "${1}" =~ ^[[:digit:]]+$ ]] || [[ -z "${1}" ]] || exit

sNumber="$1"

sDB=/var/local/spines/spinesdb.txt
sMusic=/mnt/Music/
sW="500"
sH="${sW}"
sBoF="back"
[[ "${0##*/}" = "getfront.sh" ]] && sBoF="cover"

[[ -r /etc/spines.conf ]] && . /etc/spines.conf

if [[ -z "${sNumber}" ]]
then
  sFile=$(echo "currentsong" | socat - UNIX-CONNECT:/run/mpd/socket | grep "file:")
  if [[ -n "${sFile}" ]]
  then
    sFile=${sFile#"file: "}
    sFile=$(tr -s / <<< "${sFile}")
    sFile=${sFile#"$sMusic"}
    sNumber=$(grep "${sFile%/*}" < "${sDB}"|cut -f1 -d\| )
  fi
fi

IFS=\| read sId sPath sDate sReleaseType sArtist sYear sAlbum <<< $(grep -e "^${sNumber}|" "${sDB}")
sPathx="${sMusic}/${sPath%/*}"

sImg=$(ls "${sPathx}/${sBoF}.jpg" "${sPathx}/${sBoF}.png"|head -1)

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
  sSVG="${sSVG}<rect width=\"100%\" height=\"100%\" fill=\"gainsboro\" stroke=\"black\" />"
  sSVG="${sSVG}<line x1=\"0\" y1=\"0\" x2=\"${sW}\" y2=\"${sH}\" stroke=\"black\" />"
  #sSVG="${sSVG}<text font-size=\"10\" text-anchor=\"middle\" x=\"$((sW/2))\" y=\"$((sH/2))\">${sText}</text>"
  sSVG="${sSVG}</svg>"
  echo "Content-type: image/svg+xml"
  echo "Content-length: ${#sSVG}"
  echo ""
  echo "${sSVG}"
fi
