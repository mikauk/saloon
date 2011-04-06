proc
	StripNonHex(X)
		if(!istext(X)) return X
		var
			len = length(X)
		. = ""
		for(var/i = 1; i <= len; i++)
			var/ch = text2ascii(X, i)
			if((ch >= 0x30 && ch <= 0x39) || (ch >= 0x41 && ch <= 0x46) || (ch >= 0x61 && ch <= 0x66))
				. += ascii2text(ch)
			else
				return
client
	proc
		LoadInterface()
			winset(src,"Main","size=690x450")

			if(!src.Colors)winset(src,"ChatSettings.togglecolors_off","is-checked=true")

			if(src.WhoSide)
				src.AdjustWholist(1)
				winset(src,"ChatSettings.userlist_right","is-checked=true")
			else
				src.AdjustWholist()
				winset(src,"Main.MainChild","splitter=20")

			winset(src,"ChatSettings.input_outputstyle","text=\"[src.Output_Style]\"")
			winset(src,"Output.Output","style=\"body{font-family:[src.Output_Style]}")

			winset(src,"ChatSettings.input_namecolor","text=\"[src.Name_Color]\";text-color=#[src.Name_Color]")

			winset(src,"ChatSettings.input_textcolor","text=\"[src.Text_Color]\";text-color=#[src.Text_Color]")

			winset(src,"ChatSettings.input_status","text=\"I have gone away.\"")

			winset(src,"TelnetSettings.input_telnetpassword","text=\"[TelnetPass(src)]\"")
			winset(src,"TelnetSettings.input_dtc","text=\"[TelnetCmd(src)]\"")

		SaveSetting(setting)
			var/savefile/F = new("Chatters/[src].sav")
			switch(setting)
				if(1)F["[src]/Colors"] << src.Colors
				if(2)F["[src]/WhoSide"] << src.WhoSide
				if(5)F["[src]/Output_Style"] << src.Output_Style
				if(6)F["[src]/Name"] << src.Name_Color
				if(7)F["[src]/Text"] << src.Text_Color

		AdjustWholist(side)
			if(side)
				winset(src,"Main.LeftChatters","is-visible=false")
				winset(src,"Main.RightChatters","is-visible=true")
				//winset(src,"Main.Topic","pos=10,0")
				winset(src,"Main.MainChild","splitter=80;left=Output;right=WhoList")
			else
				winset(src,"Main.LeftChatters","is-visible=true")
				winset(src,"Main.RightChatters","is-visible=false")
				//winset(src,"Main.Topic","pos=132,0")
				winset(src,"Main.MainChild","splitter=20;left=WhoList;right=Output")

	verb
		LoadCenter()
			set hidden = 1
			if(winget(src,"ControlCenter","is-visible")=="true")
				winset(src,"ControlCenter","is-visible=false")
			else winset(src,"ControlCenter","is-visible=true")

		setColors()
			set hidden = 1
			var/flag = winget(src,"ChatSettings.togglecolors_on","is-checked")
			if(flag == "true")src.Colors = 1
			else src.Colors = 0
			if(!WORKING) SaveSetting(1)

		setWhoSide()
			set hidden = 1
			var/flag = winget(src,"ChatSettings.userlist_left","is-checked")
			if(flag == "true")
				src.WhoSide = 0
				src.AdjustWholist()
			else
				src.WhoSide = 1
				src.AdjustWholist(1)
			if(!WORKING) SaveSetting(2)

		SetTelnetPass(var/pass as text)
			set hidden = 1
			winset(src,"TelnetSettings.input_telnetpassword","text=\"[pass]\"")
			var/cmd = winget(src,"ChatSettings.input_dtc","text")
			SetTelnetInfo(src, pass, cmd)

		SetTelnetCMD(var/cmd as text)
			set hidden = 1
			winset(src,"TelnetSettings.input_dtc","text=\"[cmd]\"")
			var/pass = winget(src,"ChatSettings.input_telnetpassword","text")
			SetTelnetInfo(src, pass, cmd)

		setOutput(var/style as text|null)
			set hidden = 1
			if(isnull(style))
				winset(src,"ChatSettings.input_outputstyle","text=\"[src.Output_Style]\"")
			else
				src.Output_Style = style
				winset(src,"ChatSettings.input_outputstyle","text=\"[src.Output_Style]\"")
				winset(src,"Output.Output","style=\"body{font-family:[style]}")
				if(!WORKING) SaveSetting(5)

		setNameColor(var/color as text|null)
			set hidden = 1
			if(isnull(color))winset(src,"ChatSettings.input_namecolor","text=\"[src.Name_Color]\";text-color=#[src.Name_Color]")
			else
				src.Name_Color = StripNonHex(color)
				winset(src,"ChatSettings.input_namecolor","text=\"[src.Name_Color]\";text-color=#[src.Name_Color]")
				if(!WORKING) SaveSetting(6)

		setTextColor(var/color as text|null)
			set hidden = 1
			if(isnull(color))winset(src,"ChatSettings.input_textcolor","text=\"[src.Text_Color]\";text-color=#[src.Text_Color]")
			else
				src.Text_Color = StripNonHex(color)
				winset(src,"ChatSettings.input_textcolor","text=\"[src.Text_Color]\";text-color=#[src.Text_Color]")
				if(!WORKING) SaveSetting(7)

		setAvailable()
			set hidden = 1
			var/status = winget(src,"ChatSettings.input_status","text")
			if(length(status)>0)
				setStatus("Available",status)
			else
				setStatus("Available")
		setAway()
			set hidden = 1
			var/status = winget(src,"ChatSettings.input_status","text")
			if(length(status)>0)
				setStatus("Away",status)
			else
				setStatus("Away")
		setBusy()
			set hidden = 1
			var/status = winget(src,"ChatSettings.input_status","text")
			if(length(status)>0)
				setStatus("Busy",status)
			else
				setStatus("Busy")