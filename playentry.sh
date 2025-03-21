#!/bin/bash
shopt -s nullglob

[[ "${1}" =~ ^[[:digit:]]+$ ]] || exit
sMPDHost=localhost
sMPDPort=6600

sNumber="$1"
sDB=/var/local/spines/spinesdb.txt

[[ -r /etc/spines.conf ]] && . /etc/spines.conf

IFS=\| read sId sPath sDate sReleaseType sArtist sYear sAlbum <<< $(grep -e "^${sNumber}|" "${sDB}")
sPathx="${sMusic%/}/${sPath}"

#sCmd="command_list_begin\nclear\n"
sCmd="command_list_begin\nclear\nrandom 0\n"

if [[ "${sPathx##*.}" == "m3u" ]] || [[ "${sPathx##*.}" == "cue" ]]
then
  sCmd="${sCmd}load \"file:///${sPathx}\"\n"
# while read sSong
# do
#   sCmd="${sCmd}add \"file:///${sPathx%/*}/${sSong}\"\n" 
# done <<< $(grep -v "^#" "${sPathx}")
else
  for sSong in "${sPathx%/*}"/*.{flac,mp3}
  do
    sCmd="${sCmd}add \"file:///${sSong}\"\n" 
  done  
fi
echo "Content-type: text/plain;"
echo ""
echo -e "${sCmd}play\ncommand_list_end\nclose" | socat - UNIX-CONNECT:/run/mpd/socket
#echo -e "${sCmd}play\ncommand_list_end\nclose" | nc $sMPDHost $sMPDPort
