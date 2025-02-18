#!/bin/bash

#peter@tinybee:~/spines$ head /var/local/spines/spinesm3u.txt 
#2|/Albums/A-Ha/A-Ha 1985 Hunting High and Low/album.m3u|1665960438|Album|A-ha|1985|Hunting High and Low|

sDB=/var/local/spines/spinesdb.txt
[[ -r /etc/spines.conf ]] && . spines.conf

echo "Content-type: application/json;"
echo ""
echo "{\"albums\": ["
{
cut -f1,4,5,6,7 -d\| "${sDB}" | grep "|album|" | sort -k2 -t \| -d -f
cut -f1,4,5,6,7 -d\| "${sDB}" | grep "|classical|" | sort -k2 -t \| -d -f
cut -f1,4,5,6,7 -d\| "${sDB}" | grep "|compilation|" | sort -k5 -t \| -d -f
cut -f1,4,5,6,7 -d\| "${sDB}" | grep "|soundtrack|" | sort -k5 -t \| -d -f
} |
while IFS=\| read sId sReleaseType sArtist sYear sAlbum
do
   [[ -z "${sYear}" ]] && sYear=0000
   echo "${sComma}{\"id\": ${sId},\"artist\": \"${sArtist}\", \"year\": \"${sYear}\", \"album\": \"${sAlbum//'"'/'\"'}\", \"releastype\": \"${sReleaseType}\"}"
   sComma=","
done
echo "]}"
