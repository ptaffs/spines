#!/bin/bash

echo "Content-type: text/plain;"
echo ""
echo "next" | socat - UNIX-CONNECT:/run/mpd/socket
