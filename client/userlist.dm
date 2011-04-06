
/**************************************************************************************************/
/*                                    WHO LIST GRID THINGER                                       */
/**************************************************************************************************/

client
	verb
		returnClient()
			set hidden = 1
			if(src.Status != Available)
				setStatus("Available")

client
	proc
		UserList()
			while(src)
				// Make them go Idle if they are available.
				if(src.inactivity/10 >= 1800 && src.Status == Available && !IsTelnet())
					setStatus("Idle")

				// Count the chatters
				var/Active = Available.len
				var/Chatters = Available.len + Idle.len + Busy.len + Away.len

				winset(src,"UserCount.Users","text=\"[Active]   /   [Chatters]\"")
				winset(src,"UserCount.Users","text=\"CHATTERS\n[Active]   /   [Chatters]\"")

				if(winget(src,"Main.Input","text") != src.Inputted && length(winget(src,"Main.Input","text")) > 2)
					if(src.Status == Idle || src.Status == Away || src.Status == Busy)
						winset(src,null,"command=returnClient")
					src.Inputted = winget(src,"Main.Input","text")
					src.Typing = 1
				else
					Typing = 0

				if(Typing) mob.icon_state = "Typing"
				else if(Status == Available) mob.icon_state = "Available"
				else if(Status == Idle) mob.icon_state = "Idle"
				else if(Status == Away)	mob.icon_state = "Away"
				else if(Status == Busy)	mob.icon_state = "Busy"


				src.UpdateWho()
				sleep(5)

		UpdateWho()

			var ChattersList = 1

			//winset(src,"WhoList.WhoGrid","cells=1x[ChattersList]")

			if(Available.len>1)BubbleSort(Available)
			for(var/client/C in Available)
				winset(src,"WhoGrid.WhoGrid","current-cell=1,[ChattersList]")
				winset(src,"WhoGrid.WhoGrid","style=\"body{color:[C.Grid_Color];font-weight:[C.Font_Weight];font-size:12px;}")
				src<< output(C.mob,"WhoGrid.WhoGrid")
				ChattersList++

			if(Away.len>1)BubbleSort(Away)
			for(var/client/C in Away)
				winset(src,"WhoGrid.WhoGrid","current-cell=1,[ChattersList]")
				winset(src,"WhoGrid.WhoGrid","style=\"body{color:gray;font-weight:lighter;font-size:12px;}")
				src<< output(C.mob,"WhoGrid.WhoGrid")
				ChattersList++

			if(Busy.len>1)BubbleSort(Busy)
			for(var/client/C in Busy)
				winset(src,"WhoGrid.WhoGrid","current-cell=1,[ChattersList]")
				winset(src,"WhoGrid.WhoGrid","style=\"body{color:gray;font-weight:lighter;font-size:12px;}")
				src<< output(C.mob,"WhoGrid.WhoGrid")
				ChattersList++

			if(Idle.len>1)BubbleSort(Idle)
			for(var/client/C in Idle)
				winset(src,"WhoGrid.WhoGrid","current-cell=1,[ChattersList]")
				winset(src,"WhoGrid.WhoGrid","style=\"body{color:gray;font-weight:lighter;font-size:12px;}")
				src<< output(C.mob,"WhoGrid.WhoGrid")
				ChattersList++

			winset(src,"WhoGrid.WhoGrid","cells=1x[ChattersList-1]")