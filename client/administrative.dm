/**************************************************************************************************/
/*                                    CHARTS                                                      */
/**************************************************************************************************/

client/verb
	ChartList()
		var
			counter = 0
			savefile/Chart = new("saves/chart.sav")
			ChartHeader = "<html><head><title>Chart</title>"
			tableheader = "<tr><th>Key Name</th><th>Notes</th><th>Incidents</th></tr>"
			HTML = {"<table class="moderation"><tr><th colspan="3">Chart</th>"}
		HTML += tableheader
		Chart.cd = "/"
		Chart.eof=-1
		for(var/C in Chart.dir)
			if(!Chart["[C]/Incident1/Name"]) continue
			if(counter==10)
				HTML+=tableheader
				counter=0
			else
				counter++
			HTML += {"
				<tr>
					<td align="center">[copytext(Chart["[C]/Incident1/Name"],1,15)]</td>
					<td align="center"><a href="?action=AdminPage;user=[C];page=ViewReport;">Click for Reports</a></td>
					<td align="center">[Chart["[C]/Incidents"]]</td>
			"}
		var/FullPage = "[ChartHeader][CSS][HTML][Footer]"
		src<<browse(FullPage,"window=moderation;size=400x400;can_resize=0")
client/proc
	MakeIncident(name, Reason, Moderator, Punishment)
		var/savefile/Chart = new("saves/chart.sav")
		if(Chart["[ckey(name)]/Incident1/Name"]==ckey(name))
			Chart["[ckey(name)]/Incidents"] << Chart["[ckey(name)]/Incidents"]+1
			Chart["[ckey(name)]/Incident[Chart["[ckey(name)]/Incidents"]]/Name"] << ckey(name)
			Chart["[ckey(name)]/Incident[Chart["[ckey(name)]/Incidents"]]/Reason"] << Reason
			Chart["[ckey(name)]/Incident[Chart["[ckey(name)]/Incidents"]]/Date"] << time2text(world.timeofday,"Day, Month DD.")
			Chart["[ckey(name)]/Incident[Chart["[ckey(name)]/Incidents"]]/Time"] << time2text(world.timeofday,"hh:mm:ss")
			Chart["[ckey(name)]/Incident[Chart["[ckey(name)]/Incidents"]]/Moderator"] << Moderator
			Chart["[ckey(name)]/Incident[Chart["[ckey(name)]/Incidents"]]/Punishment"] << Punishment
			Chart["[ckey(name)]/Incident[Chart["[ckey(name)]/Incidents"]]/ReportNumber"] << "#[time2text(world.timeofday,"YYYY")]-[Chart["[ckey(name)]/Incidents"]]"
		else
			Chart["[ckey(name)]/Incidents"] << 1
			Chart["[ckey(name)]/Incident1/Name"] << ckey(name)
			Chart["[ckey(name)]/Incident1/Reason"] << Reason
			Chart["[ckey(name)]/Incident1/Date"] << time2text(world.timeofday,"Day, Month DD.")
			Chart["[ckey(name)]/Incident1/Time"] << time2text(world.timeofday,"hh:mm:ss")
			Chart["[ckey(name)]/Incident1/Moderator"] << Moderator
			Chart["[ckey(name)]/Incident1/Punishment"] << Punishment
			Chart["[ckey(name)]/Incident[Chart["[ckey(name)]/Incidents"]]/ReportNumber"] << "#[time2text(world.timeofday,"YYYY")]-1"

	ViewReport(source)
		var/savefile/Chart=new("saves/chart.sav")
		var ChartHeader = "<html><head><title>[source]</title>"
		var HTML={"<table class="moderation2"><tr><th>Incident Reports</th><th>[Chart["[ckey(source)]/Incident1/Name"]]</th></tr>"}
		for(var/i=1, i<=Chart["[ckey(source)]/Incidents"],i++)
			HTML+={"<tr><th><a href="#incident[i]">Incident #[i]</th><td>[Chart["[ckey(source)]/Incident[i]/Date"]]</td></tr>"}
		HTML+="</table><br /><br />"
		Chart.cd="/"
		var counter=Chart["[ckey(source)]/Incidents"]
		for(var/i=1, i<=counter, i++)
			HTML+={"
				<a name="incident[i]">
				<table class="moderation2">
					<tr><th colspan="2">Incident #[i]</th></tr>
					<tr><th>Moderator</th><td>[Chart["[ckey(source)]/Incident[i]/Moderator"]]</td></tr>
					<tr><th>Date</th><td>[Chart["[ckey(source)]/Incident[i]/Date"]]</td></tr>
					<tr><th>Time</th><td>[Chart["[ckey(source)]/Incident[i]/Time"]]</td></tr>
					<tr><th>Action</th><td>[Chart["[ckey(source)]/Incident[i]/Punishment"]]</td></tr>
					<tr><td colspan="2"><center><b><u>Reason</u></b></center>[Chart["[ckey(source)]/Incident[i]/Reason"]]</td></tr>
				</table>
				<br /><br /><br />
				"}
		var/FullPage = "[ChartHeader][CSS][HTML][Footer]"
		src<<browse(FullPage,"window=chart;size=440x400;can_resize=0")


/**************************************************************************************************/
/*                                    ADMIN FORMS                                                 */
/**************************************************************************************************/

var
	Header = "<html><head><title>Moderation</title>"
	Footer = "</body></html>"
	CSS = {"<style type = "text/css">
body{background: #000; color: #CCC;}
.moderation{background: #1133FF; border: 2px groove #1133FF; width: 400px; padding: 0px; position: absolute; left: 0px; top: 0px}
.moderation td, .moderation th{background: #000; border: 2px groove #66AADD; width: 50%;}
.moderation2{background: #1133FF; border: 2px groove #1133FF; width: 400px; padding: 0px; position: relative; left: 0px; top: 0px}
.moderation2 td, .moderation2 th{background: #000; border: 2px groove #66AADD; width: 50%;}
.select select{width: 100%;}
textarea{width: 100%; height: 100%;}
.taller{height: 200px;}
</style></head><body>"}
	Javastart = {"<script style="javascript">
		function Moderate() {
			if(document.moderate.chatters.selectedIndex!=-1) {
				var user = document.moderate.chatters\[document.moderate.chatters.selectedIndex].text;
			}
			else {
				var user = "null";
			}"}

client/proc
	Administrate(user, action, reason)
		if(!(ckey in Admins)) return
		if(action == "Mute")
			if(user in MuteList)
				System_UserMessage(src,"[user] is already muted.")
			else
				System_WorldMessage("[user] has been muted.")
				MuteList+=user
				MakeIncident(user, reason, src.name, "Mute")

		else if(action == "Ban")
			if(user in Banned)
				System_UserMessage(src,"[user] is already banned.")
			else
				System_WorldMessage("[user] has been banned.")
				Banned+=user
				MakeIncident(user, reason, src.name, "Ban")
				for(var/client/C)
					if(C.key == user)
						del(C)

		else if(action == "Unmute")
			if(user in MuteList)
				System_WorldMessage("[user] is no longer muted.")
				MuteList-=user
			else
				System_UserMessage(src,"[user] is not muted.")


		else if(action == "Unban")
			if(user in Banned)
				System_WorldMessage("[user] is no longer banned.")
				Banned-=user
			else
				System_UserMessage(src,"[user] is not banned.")

client/Topic(href,href_list[])
	..()
	switch(href_list["action"])
		if("AdminPage")
			if(!(ckey in Admins)) return
			if(href_list["page"]=="Chart")
				ChartList()
				return
			if(href_list["page"]=="ViewReport")
				ViewReport(href_list["user"])
				return
			if(href_list["page"]=="reboot")
				src<<browse(null,"window=moderation")
				System_WorldMessage("[src.key] has called for a reboot. Reboot scheduled for 30 seconds.")
				Reboot=TRUE
				spawn(300)
					if(Reboot)
						System_WorldMessage("REBOOT (byond://[world.internet_address]:[world.port])")
						world.Reboot()
				return
			if(href_list["page"]=="cancel")
				src<<browse(null,"window=moderation")
				System_WorldMessage("[src.key] has canceled the reboot.")
				Reboot=FALSE
				return


client/Admin/verb
	Admin()
		set hidden = 1
		if(!(ckey in Admins))
			return
		else
			if(Reboot)
				winset(src,"AdminSettings.admin_ServerStatus","text=\"Server will reboot in [RebootTimer] seconds.\"")
				winset(src,"AdminSettings.admin_inputtime","text=0")
			else
				winset(src,"AdminSettings.admin_ServerStatus","text=\"Server is currently running.\"")
				winset(src,"AdminSettings.admin_inputtime","text=[RebootTimer]")

			winset(src,"AdminSettings.admin_charlimit","text=[LengthLimit]")
			winset(src,"AdminSettings.admin_topic","text=\"[ConversationTopic]\"")
			winset(src,"AdminActions.admin_reason","text=\"Spam\"")

			winset(src,"AdminConsole","is-visible=true")

	RebootButton()
		set hidden = 1
		if(!(ckey in Admins))
			return
		else
			var/timer = text2num(winget(src,"AdminSettings.admin_inputtime","text"))
			if(timer == 0)
				Reboot = FALSE
				System_WorldMessage("[src] has canceled the reboot.")
			else
				if(Reboot == TRUE)
					RebootTimer = timer
					System_WorldMessage("[src] has set the reboot timer to [RebootTimer] seconds.")
				else
					Reboot = TRUE
					RebootTimer = timer
					System_WorldMessage("[src] has called for a reboot in [RebootTimer] seconds.")
					RebootWorld()

	SetCharLimit()
		set hidden = 1
		if(!(ckey in Admins))
			return
		else
			var/newlimit = text2num(winget(src,"AdminSettings.admin_charlimit","text"))
			if(newlimit == LengthLimit) return
			else
				LengthLimit = newlimit
				System_WorldMessage("[src] has set the character limit to [LengthLimit].")

	SetTopic()
		set hidden = 1
		if(!(ckey in Admins))
			return
		else
			var/newtopic = winget(src,"AdminSettings.admin_topic","text")
			if(newtopic == ConversationTopic) return
			else
				ConversationTopic = newtopic
				for(var/client/M) {winset(M,"Main.Topic","text=\"[ConversationTopic]\"")}
				System_WorldMessage("[src] has changed the topic.")

	Punish()
		set hidden = 1
		if(!(ckey in Admins))
			return
		else
			var/target = winget(src,"AdminActions.admin_userinput","text")
			var/reason = winget(src,"AdminActions.admin_reason","text")
			if(!target)
				return
			else
				if(winget(src,"AdminActions.admin_mute","is-checked"))
					Administrate(target,"Mute", reason)
				else if(winget(src,"AdminActions.admin_voice","is-checked"))
					Administrate(target,"Unmute")
				else if(winget(src,"AdminActions.admin_ban","is-checked"))
					Administrate(target,"Ban", reason)
				else if(winget(src,"AdminActions.admin_forgive","is-checked"))
					Administrate(target,"Unban")
				else return
proc
	RebootWorld()
		while(RebootTimer>=0&&Reboot)
			RebootTimer--
			for(var/client/C)
				if(C.ckey in Admins)
					winset(C,"AdminSettings.admin_ServerStatus","text=\"Server will reboot in [RebootTimer] seconds.\"")
			if(RebootTimer==0)
				System_WorldMessage("REBOOT (byond://[world.internet_address]:[world.port])")
				world.Reboot()
			sleep(10)