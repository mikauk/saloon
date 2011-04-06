mob/Login()
	src.icon = 'status.dmi'
	if(src.client.IsTelnet())
		src.icon_state = "Telnet"
	else
		src.icon_state = src.client.Status
	..()

/**************************************************************************************************/
/*                                    Individual Chatters                                         */
/**************************************************************************************************/

Pastebin/Accepted(list/info) {
	for(var/client/C) {
		if(!C.IsTelnet()) {
			System_UserMessage(C, "[info["author"]] has posted a new pastebin. You can view it <a href=\"?action=pastebin_view&id=[url_encode(info["ID"])]\">here</a>")
		} else {
			System_UserMessage(C, "[info["author"]] has posted a new pastebin. You can view it <a href=\"[info["URL"]]\">here</a>")
		}
	}
}

client

	/* Chatter specific variables */
	var
		Grid_Color = "black"
		Font_Weight = "normal"

		list/Status = null
		Inputted = 0
		Typing = 0
		Colors = 1

		name = ""

		Name_Color = "000000"
		Text_Color = "000000"
		Output_Style = "MS Sans Serif"

		Status_Message = "Available"
		WhoSide = 0

		default_cmd = ""


		/* Save the chatters name/text colors */
	proc
		SaveMe()
			var/savefile/F = new("Chatters/[src].sav")
			F["[src]/Colors"]<<src.Colors
			F["[src]/WhoSide"]<<src.WhoSide
			F["[src]/Output"]<<src.Output_Style
			F["[src]/Name"]<<src.Name_Color
			F["[src]/Text"]<<src.Text_Color

		LoadMe()
			if(fexists("Chatters/[src].sav"))
				var/savefile/F = new("Chatters/[src].sav")
				F["[src]/Colors"]>>src.Colors
				F["[src]/WhoSide"]>>src.WhoSide
				F["[src]/Output"]>>src.Output_Style
				F["[src]/Name"]>>src.Name_Color
				F["[src]/Text"]>>src.Text_Color
		IsMuted()
			return (MuteList && (key in MuteList))

	New()
		if(!WORKING) src.LoadMe()
		. = ..()
		if(!IsTelnet())
			name = key
			winset(src,"Main","menu=main")
			winset(src,"Main.Topic","text=\"[ConversationTopic]\"")

			src<<Welcome

			System_WorldMessage("[src.name] has logged in.")
			System_UserMessage(src,ConversationTopic)

			if(src.ckey in Admins)
				src.verbs+=typesof(/client/Admin/verb)
				winset(src,"Main","menu=Admin")
				src.Grid_Color = "#9966CC"
				src.Font_Weight = "bold"

		else
			// Telnet user.
			name = copytext(key, findtext(key, "@"))
			mob.name = name
			System_WorldMessage("[src.name] has logged in.")
			System_UserMessage(src,ConversationTopic)
		Available+=src
		Status = Available
		src.LoadInterface()
		spawn() src.UserList()

	Del()
		if(!WORKING) src.SaveMe()
		if(src) Status -= src
		if(src.key in Banned)
			..()
		else
			System_WorldMessage("[src.name] has logged out.")
			..()