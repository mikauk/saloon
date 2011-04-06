/**************************************************************************************************/
/*                                    HELLZ YEAH A RADIO                                          */
/**************************************************************************************************/

client/var

	// Reloads the page to where the digital station resides
	RedirectTop ={"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
                      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'>
<head>
	<title>Radio</title>
	<meta http-equiv="refresh" content="1;url="}
	RedirectBottom = {"" />
</head>
<body>
<p>Now loading...</p>
</body>
</html>"}

	// Embeds the players in the browser because IE is retarded
	EmbedTop ={"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
                      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'>
<head>
	<title>Radio</title>
	</head>
<body><embed width="100%" height="100%" src=""}

	EmbedBottom = {"" /></div></body></html>"}




	// Stations
	Q107 = "http://corusmedia.media.streamtheworld.com/player/Player.htm?id=cilqfm&city=Toronto&bdskey=4831&url=http://www.q107.com&platform=EMMISFM&active=true"

	Buzz = {"http://www.181.fm/asx.php?station=181-buzz"}

	CBTest="http://www.bbc.co.uk/iplayer/console/bbc_1xtra"

client/proc
	LoadStation(station, type, width, height)
		if(type==1)
			src<<browse("[RedirectTop][station][RedirectBottom]","window=radio;size=[width]x[height],can-resize=0")
		else
			src<<browse("[EmbedTop][station][EmbedBottom]","window=radio;size=[width]x[height],can-resize=0")

client/verb
	Q107()
		set hidden = 1
		LoadStation(Q107, 1, 795, 547)

	Buzz()
		set hidden = 1
		LoadStation(Buzz, 2, 300, 180)