client
	proc
		LoadInterface()
			winset(src,"Main","size=690x450")

			if(!src.Colors)winset(src,"ControlCenter.togglecolors_off","is-checked=true")

			if(src.WhoSide)
				src.AdjustWholist(1)
				winset(src,"ControlCenter.userlist_right","is-checked=true")
			else
				src.AdjustWholist()
				winset(src,"Main.MainChild","splitter=20")

			winset(src,"ControlCenter.input_outputstyle","text=\"[src.Output_Style]\"")
			winset(src,"Output.Output","style=\"body{font-family:[src.Output_Style]}")

			winset(src,"ControlCenter.input_namecolor","text=\"[src.Name_Color]\";text-color=#[src.Name_Color]")

			winset(src,"ControlCenter.input_textcolor","text=\"[src.Text_Color]\";text-color=#[src.Text_Color]")


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
			if(winget(src,"ControlCenter","is-visible")=="true")
				winset(src,"ControlCenter","is-visible=false")
			else winset(src,"ControlCenter","is-visible=true")

		setColors()
			set hidden = 1
			var/flag = winget(src,"ControlCenter.togglecolors_on","is-checked")
			if(flag == "true")src.Colors = 1
			else src.Colors = 0
			if(!WORKING) SaveSetting(1)

		setWhoSide()
			set hidden = 1
			var/flag = winget(src,"ControlCenter.userlist_left","is-checked")
			if(flag == "true")
				src.WhoSide = 0
				src.AdjustWholist()
			else
				src.WhoSide = 1
				src.AdjustWholist(1)
			if(!WORKING) SaveSetting(2)

		SetTelnetPass(var/pass as text)
			set hidden = 1
			winset(src,"ControlCenter.input_telnetpassword","text=\"[pass]\"")
			var/cmd = winget(src,"ControlCenter.input_dtc","text")
			if(istext(pass) && istext(cmd))
				if(!TelnetInfo) TelnetInfo = new
				TelnetInfo[src.ckey] = list("pwd" = pass, "cmd" = cmd, "uname" = src.key)

		SetTelnetCMD(var/cmd as text)
			set hidden = 1
			winset(src,"ControlCenter.input_dtc","text=\"[cmd]\"")
			var/pass = winget(src,"ControlCenter.input_telnetpassword","text")
			if(istext(pass) && istext(cmd))
				if(!TelnetInfo) TelnetInfo = new
				TelnetInfo[src.ckey] = list("pwd" = pass, "cmd" = cmd, "uname" = src.key)


		setOutput(var/style as text|null)
			set hidden = 1
			if(isnull(style))winset(src,"ControlCenter.input_outputstyle","text=\"[src.Output_Style]\"")
			else
				src.Output_Style = style
				winset(src,"ControlCenter.input_outputstyle","text=\"[src.Output_Style]\"")
				winset(src,"Output.Output","style=\"body{font-family:[style]}")
				if(!WORKING) SaveSetting(5)

		setNameColor(var/color as text|null)
			set hidden = 1
			if(isnull(color))winset(src,"ControlCenter.input_namecolor","text=\"[src.Name_Color]\";text-color=#[src.Name_Color]")
			else
				src.Name_Color = color
				winset(src,"ControlCenter.input_namecolor","text=\"[src.Name_Color]\";text-color=#[src.Name_Color]")
				if(!WORKING) SaveSetting(6)

		setTextColor(var/color as text|null)
			set hidden = 1
			if(isnull(color))winset(src,"ControlCenter.input_textcolor","text=\"[src.Text_Color]\";text-color=#[src.Text_Color]")
			else
				src.Text_Color = color
				winset(src,"ControlCenter.input_textcolor","text=\"[src.Text_Color]\";text-color=#[src.Text_Color]")
				if(!WORKING) SaveSetting(7)

		setAvailable()
			set hidden = 1
			setStatus("Available")
		setAway()
			set hidden = 1
			setStatus("Away")
		setBusy()
			set hidden = 1
			setStatus("Busy")