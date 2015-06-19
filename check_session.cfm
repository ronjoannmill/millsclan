<cfif 	not structKeyExists(session, "loggedin") or not session.loggedin>
	<cfset returnURL = "#cgi.script_name#?#cgi.query_string#">
	<cflocation url="payeelogin.cfm" addtoken="false">
</cfif>
	