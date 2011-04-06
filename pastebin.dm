/*
	To use this, simply include the library into your project,
	override /PasteBin/Accepted(list/info) to output it however
	you wish. Create a new /Pastebin object and  submit pastebin entries
	with /Pastebin/Submit.

	PasteBin
		domain - string, the sub-domain of Pastebin to paste to. Default is BYOND.
		expiration - string, how long the pasted code will last. Read API information
			@ http://www.pastebin.com for details
		Accepted(list/info)
			info - list,
				indices:
					"author" - Author's key that submitted the code
					"URL" - The pastebin URL of the submitted code
		Submit(client/C, T)
			C - client that submitted the code
			T - Text, the code.
*/

Pastebin
	var
		list/submissions = null
		domain = "BYOND"
		expiration = "1D"
	Topic(href, list/href_list)
		if(!submissions) submissions = new
		submissions.len++
		var/url = href_list["url"]
		submissions[submissions.len] = list("author" = href_list["author"], "URL" = url, "ID" = copytext(url, findtext(url, "/", 8) + 1))
		Accepted(submissions[submissions.len])
	proc
		Accepted(list/info)
		BuildQuery(client/C, T, text_entry = 0)
			if(!T || !istext(T) || !length(T) || !C || !istype(C)) return 0
			return {"
				<html>
					<body>
						<script type="text/javascript">
				if(window.XMLHtpRequest) {
					xmlHttp = new XMLHttpRequest();
				} else {
					xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
				}

				xmlHttp.open("POST", "http://pastebin.com/api_public.php", false);
				xmlHttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
				xmlHttp.send("paste_subdomain=[domain]&paste_expire_date=[expiration]&paste_name=[C.key]&paste_code=[url_encode(T)]&paste_format=[text_entry ? "text" : "cpp"]");
				document.location = 'byond://?src=\ref[src]&author=[C.key]&url=' + xmlHttp.responseText;
						</script>
					</body>
				</html>
				"}
		Submit(client/C, T, text_entry = 0)
			if(!T || !istext(T) || !length(T) || !C || !istype(C)) return 0
			var/jscript = BuildQuery(C, T, text_entry)
			if(!winexists(C, "pasteBrowser"))
				var/list/params = new
				var/list/windows = params2list(winget(C, null, "windows"))
				params["parent"] = windows[1]
				params["type"] = "browser"
				params["is-visible"] = "false"
				winset(C, "pasteBrowser", list2params(params))
			C << output(jscript, "pasteBrowser")
