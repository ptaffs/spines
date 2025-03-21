#!/bin/bash
[[ -r /etc/spines.conf ]] && . /etc/spines.conf


sFile=$(echo "currentsong" | socat - UNIX-CONNECT:/run/mpd/socket | grep "file:")
if [[ -n "${sFile}" ]]
then
  sFile=${sFile#"file: "}
  sFile=$(tr -s / <<< "${sFile}")
  sFile=${sFile#"$sMusic"}
  sBody=$(grep "${sFile%/*}" < "${sDB}" | cut -f1 -d\|)
else
  sBody="no entry"
fi

echo "Content-type: text/plain"
echo "Content-Length: ${#sBody}"
echo ""
echo "${sBody}"
