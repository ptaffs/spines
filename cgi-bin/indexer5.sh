#!/bin/bash

if [[ ${#HTTP_USER_AGENT} -gt 0 ]]
then
  echo "Content-type: text/plain;"
  echo ""
fi

shopt -s nullglob

sMusic=/mnt/Music
sDB=/var/local/spines/spinesdb.txt
#rm "${sDB}"

[[ -f /etc/spines.conf ]] && . /etc/spines.conf
sMax=0
[[ -r "${sDB}" ]] && sMax=$(cut -f1 -d\| ${sDB}|sort -n|tail -1)

#tr -d $'\r'
find "${sMusic}" \( -name "album.m3u" -o -name "album.cue" -o -name "compilation.m3u" -o -name "compilation.cue" -o -name "classical.m3u" -o -name "classical.cue" -o -name "soundtrack.m3u" \) |
while read sFile
do
  sFileMod=$(stat -c "%Y" "${sFile}")
  sType="${sFile##*/}"
  sType="${sType%.*}"
  if sMatch=$(grep "|${sFile#${sMusic}}|${sFileMod}|" "${sDB}")
  then
    echo "${sMatch}" >> "${sDB}.$$"
  else
    sFileUx=$(mktemp)
    sed $'s/\r$//' "${sFile}" > $sFileUx
    if [[ "${sFile##*.}" == "m3u" ]]
    then
      sArt=$(grep "#EXTART:" < "${sFileUx}")
      sArt=${sArt#*:}
      sAlb=$(grep "#EXTALB:" < "${sFileUx}")
      sAlb=${sAlb#*:}
      #this code pulls date as EXTYER:1981 or appended to EXTALB:MyAlbum (1981)
      sYr=$(grep "#EXTYER:" < "${sFileUx}")
      sYr="${sYr#*:}"
      [[ "${sAlb}" =~ \(([0-9]{4})\)$ ]] && sYr="${BASH_REMATCH[1]}"
    elif [[ "${sFile##*.}" == "cue" ]]
    then
      sArt=$(grep "^PERFORMER " < "${sFileUx}")
      sArt=$(echo "${sArt#* }" | tr -d "\"")
      sAlb=$(grep "^TITLE " < "${sFileUx}")
      sAlb=$(echo "${sAlb#* }" | tr -d "\"")
      sYr=$(grep "^REM DATE " < "${sFileUx}")
      sYr=$(echo "${sYr##* }" | tr -d "\"")
    fi
    rm $sFileUx
    [[ -z "${sArt}" ]] && echo "Warning: no artist for ${sFile}"
    [[ -z "${sYr}" ]] && { sYr=0000 ; echo "Warning: no year for ${sFile}" ; }
    [[ -z "${sAlb}" ]] && sAlb="${sFile##*/}" 
    echo "$((++sMax))|${sFile#${sMusic}}|${sFileMod}|${sType}|${sArt}|${sYr}|${sAlb}|" >> "${sDB}.$$"
  fi
done
echo "Finished index update"
mv "${sDB}.$$" "${sDB}"

echo "M3U Lint report"
cut -f2 -d\| "${sDB}" | grep ".m3u" |
while read sDBM3U
do
  sM3U="${sMusic}/${sDBM3U}"
  #sYer=$(grep "#EXTYER:" < "${sM3U}" |cut -f2 -d:)
  grep -q "#EXTART:" < "${sM3U}" || echo "${sM3U} Missing Artist"
  grep -q "#EXTALB:" < "${sM3U}" || echo "${sM3U} Missing Album"
  #[[ ${#sYer} -eq 0 ]] && echo "${sM3U} Missing Year"
  grep -v "^#" "${sM3U}"|
  while read sFile
  do
    if [[ -r "${sM3U%/*}/${sFile}" ]]
    then
#      echo "${sM3U} ${sFile} Good"
      :
    else
      echo "${sM3U} ${sFile} Missing"
    fi
  done
done
