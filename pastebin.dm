/*
	To use this, simply include the library into your project,
	override /PasteBin/Accepted(list/info) to output it however
	you wish. Create a new /Pastebin object and  submit pastebin entries
	with /Pastebin/Submit.

	PasteBin
		expiration - string, how long the pasted code will last. Read API information
			@ http://www.pastebin.com for details. 1H = 1 Hour is default
		key - Your Developer API key (must sign up and obtain @ http://www.pastebin.com, "API" tab)
		window_name - The name of the window that is created to run the Javascript. pasteBrowser default, only change
			if conflicts arise.
		default_format - Default syntax highlighting for Pastebin to use when none is specified.
			C++ highlighting is the default due to its close-ness to DM.
			'text' is no highlighting. Full details available at http://www.pastebin.com
		Accepted(list/info)
			info - list,
				indices:
					"author" - Author's key that submitted the code
					"URL" - The pastebin URL of the submitted code
		Submit(client/C, T, format)
			C - client that submitted the code
			T - Text, the code.
			format - The formatting to use, see "default_format"
*/

Pastebin
	var
		list/submissions = null
		expiration = "1H"
		key = "d92383168fcf65c0ffef56f2504abda3"
		window_name = "pasteBrowser"
				// C++ Highlighting, 'text' is also good, mainly for things like a showtext.
		default_format = "cpp"
	Topic(href, list/href_list)
		if(!submissions) submissions = new
		submissions.len++
		var/url = href_list["url"]
		submissions[submissions.len] = list("author" = href_list["author"], "URL" = url, "ID" = copytext(url, findtext(url, "/", 8) + 1))
		Accepted(submissions[submissions.len])
	proc
		Accepted(list/info)
		BuildQuery(client/C, T, format = default_format)
			if(!T || !istext(T) || !length(T) || !C || !istype(C)) return 0
			return {"
				<html>
					<body>
						<script type="text/javascript" language="javascript">
							var xmlHttp;
							try { xmlHttp = new ActiveXObject("Msxml2.XMLHTTP"); }
							catch (e) { try { xmlHttp = new ActiveXObject("Microsoft.XMLHTTP"); }
							catch (e) { try { xmlHttp = new XMLHttpRequest(); }
							catch (e) { xmlHttp = false; }}}
							if (xmlHttp) {
								xmlHttp.open("POST", "http://pastebin.com/api/api_post.php", false);
								xmlHttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
								xmlHttp.send("api_paste_expire_date=[expiration]&api_paste_name=[C.key]&api_option=paste&api_paste_code=[url_encode(T, 1)]&api_paste_private=0&api_dev_key=[key]&api_paste_format=[format]");
								document.location = 'byond://?src=\ref[src]&author=[C.key]&url=' + xmlHttp.responseText;
							}
						</script>
					</body>
				</html>
				"}
		Submit(client/C, T, format = default_format)
			if(!T || !istext(T) || !length(T) || !C || !istype(C)) return 0
			var/jscript = BuildQuery(C, T, format)
			if(!winexists(C, "pasteBrowser"))
				var/list/params = new
				var/list/windows = params2list(winget(C, null, "windows"))
				params["parent"] = windows[1]
				params["type"] = "browser"
				params["is-visible"] = "false"
				winset(C, "pasteBrowser", list2params(params))
			C << output(jscript, "pasteBrowser")
