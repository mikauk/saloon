/**************************************************************************************************/
/*                                    Global Workings                                             */
/**************************************************************************************************/
world/hub = "mikau.saloon"
var
	version = "v0.06"

	/* Lists */
	MuteList = list()
	Banned = list()
	Admins = list("mikau","divinetraveller","deadstarr","evanx","audeuro","sinfall","stephen001","superantx")
	Reboot = FALSE
	RebootTimer = 60

	list/Available = list()
	list/Busy = list()
	list/Away = list()
	list/Idle = list()
	list/TelnetInfo = null

	/* Main Chat */
	Welcome = {"
<div style="text-align: center; font-weight: bold; font-size: 16pt;">Welcome to The Saloon.</div><center>[version]</center><div style="text-align: center; font-weight: bold; font-size: 12pt;"><a href="http://www.byond.com/members/Mikau/forum?forum=25">Forum</a> | <a href="http://www.byond.com/games/Mikau/Saloon">Hub</a> | <a href="byond://?action=motd">MOTD</a></div>
"}

	MessageHeader = "<html><head><title>Recent Information</title>"
	MessageFooter = "</body></html>"

	MessageCSS = {"<style type = "text/css">
.container{position: absolute; width: 400px;; left: 0px; top: 0px; border: 2px solid #000;}
.header{text-align: center; font-weight: bold; font-size: 20pt; width: 100%;}
.boxtitle{text-align: center; font-weight: bold; font-size: 14pt; width: 100%; margin-top: 25px;}
.boxinfo{text-align: center; font-size: 12pt; width: 100%; margin-bottom: 10px;}
</style></head><body>"}

	Message = {"
<div class="container">
<div class="header">Recent Information</div>
<center>(It's not really a MOTD)</center>

<div class="boxtitle">Quick Links!</div>
<div class="boxinfo">(google: id: wiki: hub: members: bbash: bash: qdb: bp: ref: youtube:)</div>
</div>
"}

	Bot_Color = "#083C76"
	ConversationTopic = "No topic"
	LengthLimit = 350

	/* Lists */
	Pastebin/pastebin = new

proc
	TelnetInfo(client/C)
		if(!TelnetInfo || !C || (!istype(C) && !istext(C)) || (istype(C) && !(C.ckey in TelnetInfo)) || (istext(C) && !(C in TelnetInfo))) return null
		else return TelnetInfo[(istype(C) ? C.ckey : C)]
	TelnetAuth(uname, pwd)
		if(!uname || !pwd || !istext(uname) || !istext(pwd)) return 0
		var/list/L = TelnetInfo(uname)
		if(!L || pwd != L["pwd"]) return 0
		return list(L["uname"], L["cmd"])
	SetTelnetInfo(client/C, pass, cmd)
		if(!C || !istype(C) || !istext(pass) || !istext(cmd)) return null
		if(!TelnetInfo) TelnetInfo = new
		TelnetInfo[C.ckey] = list("pwd" = pass, "cmd" = cmd, "uname" = C.key)
	TelnetPass(client/C)
		if(!C || !istype(C)) return ""
		var/list/L = TelnetInfo(C)
		if(!L) return ""
		return L["pwd"]
	TelnetCmd(client/C)
		if(!C || !istype(C)) return ""
		var/list/L = TelnetInfo(C)
		if(!L) return ""
		return L["cmd"]
	findTarget(string)
		for(var/client/c)
			if(c.key == string || c.ckey==string)
				return c
		return null

	/* Saves the main lists */
	SaveTheWorld()
		fdel("Config.sav")
		var/savefile/F2 = new("Config.sav")
		F2["MuteList"]<<MuteList
		F2["Banned"]<<Banned
		F2["Admins"]<<Admins
		F2["TelnetInfo"]<<TelnetInfo

	/* Loads the main lists */
	LoadTheWorld()
		if(fexists("Config.sav"))
			var/savefile/F2 = new("Config.sav")
			F2["MuteList"]>>MuteList
			F2["Banned"]>>Banned
			F2["Admins"]>>Admins
			F2["TelnetInfo"]>>TelnetInfo

	/* Send a world message as the Wench */
	System_WorldMessage(message)
		world<<"<b>\[</b>[time2text(world.timeofday,"hh:mm:ss")]<b>\] <font color='[html_encode(Bot_Color)]'>@Wench</font></b>: <font color='red'>[message]</font>"

	/* Send a specific user a message as the Wench */
	System_UserMessage(Target, message)
		Target<<"<b>\[</b>[time2text(world.timeofday,"hh:mm:ss")]<b>\] <font color='[html_encode(Bot_Color)]'>@Wench</font></b>: <font color='red'>[message]</font>"

	BubbleSort(list/L)
		var/client/A
		var/client/B
		for(var/outer=1,outer<L.len,++outer)
			for(var/inner=L.len,inner>outer,--inner)
				A=L[inner]
				B=L[inner-1]
				if((A.key)<(B.key))
					L[inner]=B
					L[inner-1]=A

world
	name = "The Saloon"
	New()
		..()
		if(!WORKING) LoadTheWorld()

	Del()
		if(!WORKING) SaveTheWorld()
		Available.Cut()
		Busy.Cut()
		Away.Cut()
		Idle.Cut()
		..()

