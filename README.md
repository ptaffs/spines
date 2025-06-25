This has been tested on Apache2 and music player daemon (musicpd).

<ul>
  <li>Shell scripts go in /cgi-bin/</li>
  <li>Images go in html /images/</li>
  <li>html goes in html</li>
  <li>spines.html is the main index file</li>
</ul>

spines.html is the main file, includes JavaScript and CSS.

![Screenshot showing rows of record spines and HTML float text that Avril Lavigne is under the mouse pointer](https://github.com/ptaffs/spines/blob/main/screenshot.jpeg?raw=true)

/etc/spines.conf<br>
<code>sDB=/var/local/spines/spinesdb.txt
#sMusic=/mnt/Music/
sMusic=/mnt/usb/Music/
sWidth=50
sDev="hw:CARD=UA1A,DEV=0"</code>

Albums are created by having a correctly named playlist and optionally, but importantly a spine.jpg, back.jpg and cover.jpg. The album can be (flac/)cue or m3u playlists, these playlist files are indexed by spines, and played by mpd with the "load" instruction.

![Screenshot showing mp3 files and the additional files needed for Spines; back, cover, spine and album.m3u](https://raw.githubusercontent.com/ptaffs/spines/refs/heads/main/idealfolder.png)

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

The database, created and maintained by indexer5.sh will look like this:
<code>
tail /var/local/spines/spinesdb.txt
1586|Albums/Air/Air 2001 10,000hz Legend/album.m3u|1733280510|album|Air|2001|10 000 Hz Legend|
1587|Albums/Air/Air 2004 Talkie Walkie/album.m3u|1733280511|album|Air|2004|Talkie Walkie|
1292|Compilations/Ministry of Sound/The Annual Millennium Edition/compilation.cue|1725040042|compilation|Judge Jules & Tall Paul|1999|Ministry of Sound: The Annual - Millennium Edition|
1293|Compilations/Ministry of Sound/The Annual/compilation.cue|1725040627|compilation|Boy George And Pete Tong|1995|Ministry of Sound: The Annual|
1294|Compilations/Ministry of Sound/The Chillout Session/compilation.cue|1725040105|compilation|Ministry Of Sound|2001|Ministry of Sound: The Chillout Session|
1295|Compilations/Ministry of Sound/The Ibiza Annual 1998/compilation.cue|1725040154|compilation|Judge Jules + Boy George|1998|Ministry of Sound: The Ibiza Annual|
1296|Compilations/Ministry of Sound/The Ibiza Annual Summer 2000/compilation.cue|1725040228|compilation|Judge Jules And Tall Paul|2000|Ministry of Sound: The Ibiza Annual - Summer 2000|
1297|Compilations/Queer As Folk 2/compilation.m3u|1725041169|compilation|Various Artists|2000|Queer as Folk 2: Same Men New Tracks|
1298|Compilations/Queer As Folk/compilation.m3u|1725041588|compilation|Various Artists|1999|Queer as Folk 1: The Whole Love Thing. Sorted.|
1300|Compilations/1990 Red Hot and Blue/compilation.m3u|1725301680|compilation|Various Artists|1990|Red Hot and Blue|
1299|OST/Juno/soundtrack.m3u|1724011391|soundtrack|Barry Louis Polisar|2007|Juno|
1516|OST/Vangelis - Blade Runner (1994)(flac)/soundtrack.m3u|1728928781|soundtrack|Vangelis|1994|Blade Runner|
</code>

Pipe separated columns are index (assigned by the indexing script), path to playlist, date playlist file was read to identify whether to re-read if updated, type, artist, release date (year) and title.

playlists can be named by type inorder that the GUI presents studio albums, classical, compilation then soundtrack:
<ul><li>album.m3u or album.cue for traditional studio albums</li><li>sountrack.m3u or soundtrack.cue for movie sountrack albums</li><li>compilation or classical for those album types.</li></ul>
