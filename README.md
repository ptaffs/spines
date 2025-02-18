This has been tested on Apache2 and music player daemon (musicpd).

<ul>
  <li>Shell scripts go in /cgi-bin/</li>
  <li>Images go in html /images/</li>
  <li>html goes in html</li>
  <li>spines2.html is the main file</li>
</ul>

spines2.html is the main file

/etc/spines.conf<br>
<code>sDB=/var/local/spines/spinesdb.txt
#sMusic=/mnt/Music/
sMusic=/mnt/usb/Music/
sWidth=50
sDev="hw:CARD=UA1A,DEV=0"</code>

Albums are created by having a correctly named playlist and optionally, but importantly a spine.jpg, back.jpg and cover.jpg. The album can be flac/cue or m3u playlists, these playlist files are played by mpd with the "load".

Additional data in the playlist/cue assist presentation "REM DATE" in cue
<code>
Pet Shop Boys 1986 03 Please$ head album.cue 
PERFORMER "Pet Shop Boys"
TITLE "Please"
REM DATE 1985
FILE "Please.flac" WAVE
  TRACK 01 AUDIO
    TITLE "Two Divided by Zero"
    INDEX 01 00:00:00
  TRACK 02 AUDIO
    TITLE "West End Girls"
    INDEX 01 03:34:70
</code>

EXTART and EXTALB tags for album artist and album name and year in m3u
<code>
Pet Shop Boys 1994 Disco 2$ head album.m3u 
#EXTM3U
#EXTART:Pet Shop Boys
#EXTALB:Disco 2 (1994)
#EXTINF:29, Pet Shop Boys - Absolutely Fabulous (Rollo Our Tribe Tongue-In Cheek mix)
01 Absolutely Fabulous (Rollo Our Tribe Tongue-In Cheek mix).mp3
#EXTINF:255, Pet Shop Boys - I Wouldn't Normally Do This Kind of Thing (Beatmasters extended Nude mix)
02 I Wouldn't Normally Do This Kind of Thing (Beatmasters extended Nude mix).mp3
#EXTINF:179, Pet Shop Boys - I Wouldn't Normally Do This Kind of Thing" (DJ Pierre Wild Pitch mix)
03 I Wouldn't Normally Do This Kind of Thing_ (DJ Pierre Wild Pitch mix).mp3
</code>
