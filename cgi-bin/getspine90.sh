#!/bin/bash

[[ "${1}" =~ ^[[:digit:]]+$ ]] || exit

sNumber="$1"
sDB=/var/local/spines/spinesdb.txt
sMusic=/mnt/Music/
sH=65
sW=1180

[[ -r /etc/spines.conf ]] && . /etc/spines.conf

IFS=\| read sId sPath sDate sReleaseType sArtist sYear sAlbum <<< $(grep -e "^${sNumber}|" "${sDB}")

if [[ -n "${sId}" ]]
then
  sPathx="${sMusic}/${sPath%/*}"
  sImg=$(ls "${sPathx}/spine.jpg" "${sPathx}/spine.png"|head -1)
  if [[ -r "${sImg}" ]]
  then
    read sSW sSH <<< $( identify -ping -format '%w %h' "${sImg}" )
    sSVG="<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" version=\"1.1\" width=\"${sSH}\" height=\"${sSW}\">"
    sSVG="${sSVG}<image x=\"-${sSW}\" y=\"0\" width=\"${sSW}\" height=\"${sSH}\" xlink:href=\"data:image/${sImg##*.};base64,"$(base64 "${sImg}")"\" transform=\"rotate(-90)\"/>"
    sSVG="${sSVG}</svg>"
    echo "Content-type: image/svg+xml"
    echo "Content-length: ${#sSVG}"
    echo ""
    echo "${sSVG}"
  else #make an image SVG
    sSVG="<svg version=\"1.1\" width=\"${sW}\" height=\"${sH}\" xmlns=\"http://www.w3.org/2000/svg\">"
    sSVG="${sSVG}<rect width=\"100%\" height=\"100%\" fill=\"gainsboro\" />"
    sSVG="${sSVG}<text font-size=\"$((sH*10/15))\" text-anchor=\"middle\" x=\"$((sW/2))\" y=\"$((sH*10/15))\">${sArtist} - ${sAlbum}</text>"
    sSVG="${sSVG}</svg>"
    echo "Content-type: image/svg+xml"
    echo "Content-length: ${#sSVG}"
    echo ""
    echo "${sSVG}"
  fi
else
  sSVG="<svg version=\"1.1\" width=\"${sW}\" height=\"${sH}\" xmlns=\"http://www.w3.org/2000/svg\">"
  sSVG="${sSVG}</svg>"
  echo "Content-type: image/svg+xml"
  echo "Content-length: ${#sSVG}"
  echo ""
  echo "${sSVG}"
fi
