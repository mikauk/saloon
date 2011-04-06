/**************************************************************************************************/
/*                                    CHARTS                                                      */
/**************************************************************************************************/

client/proc
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
	AdminForm()
		var/Javascript = {"
			<script style="javascript">
				function SetTopic() {
						var topic = document.moderate.topic.value;
						document.location = 'byond://?action=Topic;topic='+topic;
					}
				function SetMessage() {
						var topic = document.moderate.message.value;
						document.location = 'byond://?action=Message;message='+topic;
					}
			</script>
			"}
		var/Page = {"
					<form name="moderate" method="get">
					<table class="moderation">
					<tr><th colspan="2">Moderation Forms</th></tr>
					<tr><th><a href="byond://?action=AdminPage;page=Mute;">Mute</a></th><th><a href="byond://?action=AdminPage;page=Unmute;">Unmute</a></th></tr>
					<tr><th><a href="byond://?action=AdminPage;page=Ban;">Ban</a></th><th><a href="byond://?action=AdminPage;page=Unban;">Unban</a></th></tr>
					<tr><th><a href="byond://?action=AdminPage;page=Kick;">Kick</a></th><th><a href="byond://?action=AdminPage;page=Chart;">View the Charts</th></tr>
					<tr><th><a href="byond://?action=AdminPage;page=reboot">REBOOT</th><th><a href="byond://?action=AdminPage;page=cancel">CANCEL</th></tr>
					<tr><th colspan="2">Reboot Status: [REBOOT]</th></tr>
					<tr><th colspan="2">Current Topic</th></tr>
					<tr><td colspan="2"><textarea name="topic">[ConversationTopic]</textarea></td></tr>
					<tr><td colspan="2" class="taller"><textarea name="message">[Message]</textarea></td></tr>
					<tr><th><input type="button" value="Set Topic" onclick="SetTopic(this.form)" /></th><th><input type="button" value="Set Message" onclick="SetMessage(this.form)" /></th></tr>
					</table>
					</form>
				"}
		var/Full_Page = "[Header][Javascript][CSS][Page][Footer]"
		src<<browse(Full_Page,"window=moderation;size=400x460;can_resize=0")

	PunishForm(type)
		var/Javascript = {"
		var punishment = "[type]";
		var reason = document.moderate.reason.value;
		document.location = 'byond://?action=Moderate;goback=no;user='+user+';punishment='+punishment+';moderator=[src];reason='+reason;}</script>"}
		var/Page = {"
					<form name="moderate" method="get">
					<table class="moderation">
						<tr><th>[type]</th><th><a href="byond://?action=Moderate;goback=yes">Return</a></th></tr>
						<tr><td class="select" colspan="2">
						<select name="chatters" size="10" multiple="multiple">"}
		if(type=="Unmute")
			for(var/Target in MuteList)
				Page+="<option>[Target]</option>"
		else if(type=="Unban")
			for(var/Target in Banned)
				Page+="<option>[Target]</option>"
		else
			for(var/client/Target)
				Page+="<option>[Target.key]</option>"
		Page+={"</select></td></tr>
						<tr><td colspan="2"><textarea name="reason" />Please give a reason.</textarea></td></tr>
						<tr><td colspan="2"><center><input type="button" value="Submit" onclick="Moderate(this.form)" /></center></td></tr>
					</table>
					</form>"}
		var/Full_Page = "[Header][Javastart][Javascript][CSS][Page][Footer]"
		src<<browse(Full_Page,"window=moderation;size=400x400;can_resize=0")


client/proc
	Administrate(action, user)
		if(!(ckey in Admins)) return
		if(action == "Mute")
			if(user in MuteList)
				System_UserMessage(src,"[user] is already muted.")
			else
				System_WorldMessage("[user] has been muted.")
				MuteList+=user

		else if(action == "Kick")
			for(var/client/C)
				if(C.key == user)
					System_WorldMessage("[user] has been kicked.")
					del(C)
					return 0
			System_UserMessage(src,"We couldn't find anyone named [user].")

		else if(action == "Ban")
			if(user in Banned)
				System_UserMessage(src,"[user] is already banned.")
			else
				System_WorldMessage("[user] has been banned.")
				Banned+=user
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
		if("Moderate")
			if(!(ckey in Admins)) return
			if(href_list["user"]=="null"||href_list["punishment"]=="null") return
			if(href_list["goback"]=="no")
				Administrate(href_list["punishment"],href_list["user"])
				MakeIncident(href_list["user"],href_list["reason"],href_list["moderator"],href_list["punishment"])
				AdminForm()
			if(href_list["goback"]=="yes") AdminForm(); return
		if("Topic")
			if(!(ckey in Admins)) return
			if(href_list["topic"]!=ConversationTopic)
				ConversationTopic = href_list["topic"]
				for(var/client/M) {winset(M,"Main.Topic","text=\"[ConversationTopic]\"")}
				System_WorldMessage("[src] has changed the topic.")

		// semicolons break me =(
		if("Message")
			if(!(ckey in Admins)) return
			if(href_list["message"]!=Message)
				Message = href_list["message"]
				System_WorldMessage("[src] has changed the login message. /MOTD to view it.")
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
				System_WorldMessage("[src.key] has called for a reboot. Reboot scheduled for 2 minutes.")
				REBOOT=TRUE
				spawn(300)
					if(REBOOT)
						System_WorldMessage("REBOOT (byond://[world.internet_address]:[world.port])")
						world.Reboot()
				return
			if(href_list["page"]=="cancel")
				src<<browse(null,"window=moderation")
				System_WorldMessage("[src.key] has canceled the reboot.")
				REBOOT=FALSE
				return
			else
				PunishForm(href_list["page"])


client/Admin/verb
	Admin()
		set hidden = 1
		if(!(ckey in Admins)) return
		AdminForm()