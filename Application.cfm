<!---application.cfm--->
<cfapplication 
		name="Mills Family" 
		sessionmanagement="Yes" 
		setclientcookies="no"
		sessiontimeout="#CreateTimeSpan(0,2,0,0)#" 
		applicationtimeout="#CreateTimeSpan(2,0,0,0)#">
<!--- <cferror type="exception" exception="application" template="iwserror.cfm"> --->
<cfset application.session_cookie="MILLSwed1994">
<cfset application.database="millsclan">
<cfset application.key="Mills2006">
<cfset application.lastedit="October 26, 2018">
<cfset application.myear=#year(now())#>
<cfif not structKeyExists(cookie, "cfid")>
	<cfset cookie.cfid = session.CFID>
	<cfset cookie.cftoken = session.CFToken>
</cfif>

<!--- <cfif CGI.SCRIPT_NAME contains "/admin">
	<cfif CGI.SERVER_NAME contains "millsclan.com" >
		<!-----------------------------------------
			FORCE SSL on gasnom.com ADMIN sites
		------------------------------------------>
		<!--- <cfif cgi.https EQ "off">
			<cflocation url="https://#cgi.server_name#/admin/" addtoken="no">
		</cfif> --->
	<cfelse>
		-------------------------------------------------------------------------
			DO NOT FORCE SSL on all other sites (ie. localhost, local.gasnom.com,
			www.stagecoachstorage.com, www.steubengasstorage.com, etc.). For admin
			purposes, they should be going to gasnom.com/ip/stagecoach/admin, etc.
		--------------------------------------------------------------------------
	</cfif>
<cfelse>
	<!--- FORCE NON-SSL (HTTP) if not in ADMIN --->
	<cfif cgi.https EQ "on">
		<cflocation url="http://#cgi.server_name#/" addtoken="no">
	</cfif>
</cfif> --->

<!---<cfif structFind(cgi, "https") neq "on">
	<cflocation url="https://#cgi.http_host##cgi.PATH_INFO#">
</cfif>--->

<cfset request.passwordSeed = "8147"><!--- don't change this, existing passwords won't work when changed --->
<cfset request.algorithm="CFMX_COMPAT">
<cfset request.encoding="Base64">


<cfset request = structNew()>
<cfset request.logFileName = "MillsClan">
<cfset request.componentRoot = "./Components">
<cfset request.InvoicePath = "">

<cfset request.cssRoot = "">
<cfset request.dsn = "">
<cfset request.customTagPath = "">
<cfset request.customImgFolder = "">
