#!/bin/bash
sComma=""

echo "Content-type: application/json;"
echo ""
echo "{"
echo "status" | socat - UNIX-CONNECT:/run/mpd/socket |
grep -v "^OK" |
while read sPair
do
  echo "${sComma}\"${sPair%%:*}\": \"${sPair##*: }\""
  sComma=","
done
echo "}"
