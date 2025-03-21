#!/bin/bash

echo "Content-type: text/plain;"
echo ""
echo "pause" | socat - UNIX-CONNECT:/run/mpd/socket
