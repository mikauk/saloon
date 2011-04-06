CommandParser
	var
		command = null
		list/params = null
	New(cmdString = "")
		Parse(cmdString)
	proc
		Parse(cmdString)
			if(!cmdString || !istext(cmdString) || !length(ckey(cmdString)) || text2ascii(cmdString, 1) == 32) return 0
			var/length = length(cmdString)
			var/cmdStr = ""
			var/str = 0
			params = null
			for(var/i = 1; i <= length; i++)
				var/ch = text2ascii(cmdString, i)
				if(ch > 32)
					if(ch == 34)
						if(str)
							if(!params) params = new
							params += cmdStr
							cmdStr = ""
							i++
							str = 0
						else if(!length(cmdStr))
							str = 1
						else
							cmdStr += ascii2text(ch)
						continue
					cmdStr += ascii2text(ch)
				else if(ch == 32 && !str)
					if(!command)
						command = cmdStr
						cmdStr = ""
						continue
					if(!params) params = new
					params += cmdStr
					cmdStr = ""
				else if(str)
					cmdStr += ascii2text(ch)
			if(length(cmdStr))
				if(!command)
					command = cmdStr
				else
					if(!params) params = new
					params += cmdStr
			return 1
		IsValid()
			return (command && istext(command))
		ArgCount()
			return (params && params.len)
		Args()
			return (params)
		Arg(index)
			return (params[min(index, params.len)])
		Implode(include_cmd = 1)
			if(!IsValid()) return 0
			if(include_cmd) . = command
			else . = ""
			if(params)
				for(var/i in params)
					. += " [i]"
		Command()
			return command
		PushCommand(new_cmd)
			params = list(command) + params
			command = new_cmd

client/Command(cmd as command_text)
	if(!IsTelnet()) return ..()
	var/CommandParser/CP = new(cmd)
	if(default_cmd && text2ascii(CP.Command(), 1) != 47) CP.PushCommand(default_cmd)
	switch(lowertext(ckeyEx(CP.Command())))
		if("default")
			if(!CP.ArgCount())
				if(default_cmd) System_UserMessage(src, "Your default command is currently [default_cmd].")
				else System_UserMessage(src, "You must enter a new command to make your default.")
			else
				default_cmd = CP.Arg(1)
		if("auth")
			if(CP.ArgCount() < 2)
				System_UserMessage(src, "You must enter a ckey and a telnet password.")
			else
				var/list/auth = TelnetAuth(CP.Arg(1), CP.Arg(2))
				if(!auth)
					System_UserMessage(src, "You have entered an invalid ckey and/or telnet password.")
				else
					default_cmd = auth[2]
					name = "@[auth[1]]"
					mob.name = name
					System_UserMessage(src, "You have successfully authenticated as [auth[1]] and your default command is now [auth[2]]")
		if("color")
			src.Color()
		if("say")
			if(!CP.ArgCount())
				System_UserMessage(src, "You must enter a message.")
			else
				Say(CP.Implode(0))
		if("emote")
			if(!CP.ArgCount())
				System_UserMessage(src, "You must enter a message.")
			else
				Emote(CP.Implode(0))
		if("who")
			var
				available = ""
				busy = ""
				away = ""
				idle = ""
			for(var/client/C in Available)
				if(length(available)) available += ", "
				available += C.name

			for(var/client/C in Busy)
				if(length(busy)) busy += ", "
				busy += C.name

			for(var/client/C in Away)
				if(length(away)) away += ", "
				away += C.name

			for(var/client/C in Idle)
				if(length(idle)) idle += ", "
				idle += C.name

			System_UserMessage(src, "Total Users: [Available.len + Busy.len + Away.len + Idle.len]")
			if(length(available)) System_UserMessage(src, "Available: [available]")
			if(length(busy)) System_UserMessage(src, "Busy: [busy]")
			if(length(away)) System_UserMessage(src, "Away: [away]")
			if(length(idle)) System_UserMessage(src, "Idle: [idle]")


client/proc/IsTelnet()
	return !computer_id
