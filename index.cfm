<cfset mdate = DateFormat(now(),"MMMM dd, yyyy")>
<cfset dow = day(mdate)>
<cfset session.loggedin = FALSE>
<cfif structKeyExists(URL,"id")>
	<cfset cid = #URL.id#>
<cfelse>
	<cfset cid = 6>
</cfif>
<cftry>
	<cfquery name="getInfo" datasource="#application.database#">
		select info from tblinfo where id = #cid#
	</cfquery>
	<cfif getInfo.recordcount gt 0>
		<cfset minfo = #getInfo.info#>
	<cfelse>
		<cfset minfo = "No Information Available">
	</cfif>
<cfcatch type="any">
	<cfmail 
		to="ron@millsclan.com" 
		from="ron@millsclan.com" 
		server="mail.millsclan.com" 
		username="ron@millsclan.com" 
		password="wed1994" 
		type="html" 
		subject="MillsClan Error - GetInfo">
		Error Message - #cfcatch.Message#<br />
		Error Detail - #cfcatch.Detail#<br />
		<cfdump var="#cfcatch#">
	</cfmail>
</cfcatch>
</cftry>

<cfoutput>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="google-site-verification" content="u4jHlz2FHIo7Mr13m3RKGwMzQ1SMNZ0RThOu1uFEedI" />
<title>The Mills Family</title>
<link rel="stylesheet" type="text/css" href="./css/millsclan.css" />
<script language="javascript">
	function go(){
		window.location="login.cfm?id=2";
		return;
	}
</script>
</head>
<body>
<div class="main">
<cfinclude template="header.cfm">
<div class="info">
#minfo#
</div>
<p style="text-align:center"><button type="button" onClick="go();">Edit</button></p>
<cfinclude template="footer.cfm">
</div>
</body>
</html></cfoutput>
