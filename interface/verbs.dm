
/**************************************************************************************************/
/*                                    All of those crazy verbs!                                   */
/**************************************************************************************************/

proc
	HasSustenance(msg)
		if(istext(msg))
			for(var/i = 1 to length(msg))
				if(text2ascii(msg, i) > 32)
					return 1

	KillNewlines(msg)
		if(!istext(msg))
			return msg
		. = ""
		var/len = length(msg)
		var/ch = 0
		for(var/i = 1; i <= len; i++)
			ch = text2ascii(msg, i)
			if(ch >= 0x20)
				. += ascii2text(ch)


client/proc
	messageParse(msg, quicklink, address)
		var
			StartChunk // Everything before the quicklink
			EndChunk // Everything after the quicklink
			Text	// The quicklink
			TextLength	// The length of what they searched.
		if(findtext(msg,quicklink))
			StartChunk = copytext(msg,1,findtext(msg,quicklink))
			Text = copytext(msg,findtext(msg,quicklink))
			Text = copytext(Text,1,findtext(Text," "))
			TextLength = length(Text)
			Text = "<a href=\"[address][copytext(Text,length(quicklink)+1)]\">[Text]</a>"
			EndChunk = copytext(msg,length(StartChunk)+TextLength+1,length(msg)+1)
			msg = "[StartChunk][Text][EndChunk]"
		return msg

	linkSearch(msg)
		msg = html_encode(msg) // no HTML for you
		var
			google = "http://www.google.com/search?q="
			developerforum = "http://www.byond.com/developer/forum/?id="
			wikipedia = "http://en.wikipedia.org/wiki/"
			byondhub = "http://www.byond.com/games/"
			byondmembers = "http://www.byond.com/members/"
			byondbash = "http://gazoot.byondhome.com/bbash/?quote="
			bash = "http://www.bash.org/?"
			qdb = "http://qdb.us/"
			byondpeople = "http://mikau.tibbius.com/byondpeople/people/"
			reference = "http://www.byond.com/members/?command=reference&path="
			youtube = "http://www.youtube.com/watch?v="
			//forum = ""  forum:mikau:43
			//http://www.byond.com/members/Mikau/forum?id=43
		msg = messageParse(msg, "google:", google)
		msg = messageParse(msg, "id:", developerforum)
		msg = messageParse(msg, "wiki:", wikipedia)
		msg = messageParse(msg, "hub:", byondhub)
		msg = messageParse(msg, "members:", byondmembers)
		msg = messageParse(msg, "member:", byondmembers)
		msg = messageParse(msg, "people:", byondmembers)
		msg = messageParse(msg, "bbash:", byondbash)
		msg = messageParse(msg, "bash:", bash)
		msg = messageParse(msg, "qdb:", qdb)
		msg = messageParse(msg, "bp:", byondpeople)
		msg = messageParse(msg, "ref:", reference)
		msg = messageParse(msg, "youtube:", youtube)
		msg = messageParse(msg, "yt:", youtube)
		return msg

	validMessageCheck(msg)
		if(src.IsMuted())
			System_UserMessage(src, "You re currently muted.")
			return 0
		else if(length(msg) > LengthLimit)
			System_UserMessage(src, "You've said too much, would you shut up?")
			return 0
		else if(!HasSustenance(msg))
			return 0
		else
			return 1



client/verb
	MOTD()
		set hidden = 1
		src<<browse("[MessageHeader][MessageCSS][Message][MessageFooter]","window=moderation;size=400x460;can_resize=0")
	Color()
		set hidden = 1
		src.Name_Color = pick("FF0000","00FF00","0000FF")
	Showcode(code as message)
		set hidden = 1
		if(!code || !istext(code) || !length(ckeyEx(code))) return 0;
		pastebin.Submit(src, code)

	Showtext(code as message)
		set hidden = 1
		if(!code || !istext(code) || !length(ckeyEx(code))) return 0;
		pastebin.Submit(src, code, 1)

	Say(msg as text)
		set
			hidden = 1
			name = ">"
		if(validMessageCheck(msg))
			setStatus("Available")
			msg = linkSearch(KillNewlines(msg))
			var/list/clients = Available + Busy + Idle + Away
			for(var/client/C in clients)
				if(!C.IsTelnet() && C.Colors) C << "<b>\[</b>[time2text(world.timeofday,"hh:mm:ss")]<b>\] <font color='#[Name_Color]'>[src.name]</font></b>: <font color='#[Text_Color]'>[msg]</font>"
				else C <<"<b>\[</b>[time2text(world.timeofday,"hh:mm:ss")]<b>\] [src.name]</b>: [msg]"

	Emote(msg as text)
		set
			hidden = 1
			name = "me"
		if(validMessageCheck(msg))
			setStatus("Available")
			msg = linkSearch(KillNewlines(msg))
			var/list/clients = Available + Busy + Idle + Away
			for(var/client/C in clients)
				if(!C.IsTelnet() && C.Colors) C << "<b>\[</b>[time2text(world.timeofday,"hh:mm:ss")]<b>\]</b> <font color='#[Name_Color]'>*[src.name] [msg]</font>"
				else C <<"<b>\[</b>[time2text(world.timeofday,"hh:mm:ss")]<b>\]</b> *[src.name]</b> [msg]"


client/Topic(href,href_list[])
	..()
	switch(href_list["action"])
		if("pastebin_view")
			src << browse("<html><head><script src=\"http://pastebin.com/embed_js.php?i=[href_list["id"]]\"></script></head><body></body></html>", "window=pastebin")
		if("motd")
			src.MOTD()


client/proc
	setStatus(type, status)
		src.Status -= src
		if(type == "Available")
			if(src.Status!=Available && !IsMuted())
				System_WorldMessage("[src.key] has returned!")
			src.Status = Available
			winset(src,"status_available","is-checked=true")

		if(type == "Away")
			if(src.Status == Available && !IsMuted())
				if(status)System_WorldMessage("[src.key] has gone away. ([status])")
				else System_WorldMessage("[src.key] has gone away.")
			src.Status = Away
			winset(src,"status_away","is-checked=true")

		if(type == "Busy")
			if(src.Status == Available && !IsMuted())
				if(status)System_WorldMessage("[src.key] is now busy. ([status])")
				else System_WorldMessage("[src.key] is now busy.")
			src.Status = Busy
			winset(src,"status_busy","is-checked=true")

		if(type == "Idle")
			if(src.Status == Available && !IsMuted())
				System_WorldMessage("[src.key] is now idle.")
			src.Status = Idle

		src.Status += src


client/verb
	afk(msg as text)
		set hidden = 1
		if(!msg) src.setStatus("Away","I have gone away.")
		else src.setStatus("Away",msg)