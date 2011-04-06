/**************************************************************************************************/
/*                                    HELLZ YEAH A RADIO                                          */
/**************************************************************************************************/

client/var

	// Reloads the page to where the digital station resides
	RadioTopReload ={"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
                      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'>
<head>
	<title>Radio</title>
	<meta http-equiv="refresh" content="1;url="}
	RadioBottomReload = {"" />
</head>
<body>
<p>Now loading...</p>
</body>
</html>"}

	// Embeds the players in the browser because IE is retarded
	RadioTopEmbed ={"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
                      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'>
<head>
	<title>Radio</title>
	</head>
<body><div style="width:500px; padding: 10px; border: 2px groove #000; text-align: center; margin: 0px auto;">"}
	RadioEmbedMiddle = {"</div><div style="width: 100%; text-align: center"><embed width="100%" height="400px" src=""}

	RadioBottomEmbed = {" /></div></body></html>"}




	// Stations
	Q107 = "http://corusmedia.media.streamtheworld.com/player/Player.htm?id=cilqfm&city=Toronto&bdskey=4831&url=http://www.q107.com&platform=EMMISFM&active=true"

	BuzzText = "This is an Alternate Rock station on The Buzz.<br />It has a real player, but it uses Silverlight.<br />So Internet Explorer is too stupid to play it without embedding."
	BuzzStation = {"http://www.181.fm/asx.php?station=181-buzz""}


client/verb
	Q107() src<<browse("[RadioTopReload][Q107][RadioBottomReload]","window=main;size=795x547;can_resize=0")

	Buzz() src<<browse("[RadioTopEmbed][BuzzText][RadioEmbedMiddle][BuzzStation][RadioBottomEmbed]","window=main;size=795x547;can_resize=0")