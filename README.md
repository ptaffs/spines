This has been tested on Apache2 and music player daemon (musicpd).

<ul>
  <li>Shell scripts go in /cgi-bin/</li>
  <li>Images go in html /images/</li>
  <li>html goes in html</li>
  <li>spines.html is the main application/index file</li>
  <li>a database in /var/local/spines/ and a collection of music and images are needed in the music folder, as configured in /etc/spines.conf
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

Screen recording showing Spines! load:

https://github.com/user-attachments/assets/5d9706c8-a6ea-432b-9bb0-4b03ef1097ca

I Still Haven't Found What I’m Looking For

Our large digital libraries have failed to recreate the same inspiring browsing experience as their physical counterparts. Walk into a small bookshop, or an apartment with shelves of records, or leaf through family photo albums, and you’ll be compelled to look—recognizing some items and becoming nostalgic or curious about others. The magic of looking vanishes on your e-reader, music app, or whatever you use for photos. Most of these solutions fall back on cover-artwork thumbnails of the most recently added or alphabetically first (Aaron Neville, ABBA, Air) twelve of two hundred—or two thousand—library items.

We could give up, because the obvious problem is that display shelving is larger than a monitor, and there’s some element of peripheral vision needed for the real thing. Also, Digital Rights Management prevents innovation because the library isn’t truly yours. And while some interesting developments in Photos will slice your collection by location, recognized faces, and timestamps, that only works where the data is available and accurate. These tools can give you the ability to see all your photos on a globe, reveal insights, and allow a deep dive.

Music really interests me, and I'm leveraging fair use to rip my CDs and LPs. I had the idea of representing my collection of albums as a book-shelf view but on the screen. After literally years of imagining how this might work, I have a prototype and wanted to share a couple of issues. The banner here on LinkedIn is a screen-grab.

First, there’s no digital “album” format. Most software determines albums by reading tags embedded in music track files, matching the album and artist names, putting them in track number order, and calling it done. This depends on impeccable tagging and creates phantom albums from orphaned tracks and albums with missing tracks. The solution I came up with was to create a playlist (m3u) for each album I wanted visible on-the-shelf, ignoring existing tags. I used the unofficial fields #EXTALB and #EXTART for album title (and year) and album artist.

While cover art is abundant and easily downloaded from the web, there is an absence of spine images. For a while, I thought I might display the left edge of the cover, as though it were a badly folded vinyl sleeve, but an awful lot of my albums are white, or have white edges, so that didn’t work. Album spines really are miniature works of art. They often represent a label identity with recognizable hallmarks, color blocks, or catalog numbers. Scanning your own CDs spines requires dismantling the brittle jewel case to remove the tray paper, on repeat.

Making playlists and scanning covers is an unsolved faff. The most contentious issue is what order to sort the albums. I went with what I have on my shelves: grouped by artist, then in release order—which is why I need the year in the title. Most software will put Pet Shop Boys – Behaviour before Please—which is patently wrong. Then there are all Taylor Swift’s versions, which, if you’re curious, I put in new-release order. Read Nick Hornby’s High Fidelity (Fiction, Author A–Z, “Hornby, Nick”) for other ways to sort albums.
